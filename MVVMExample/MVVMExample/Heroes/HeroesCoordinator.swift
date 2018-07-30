//
//  HeroesCoordinator.swift
//  CoordinatorsExample
//
//  Created by David Levi on 5/20/18.
//  Copyright © 2018 CodeTank Labs LLC. All rights reserved.
//

import UIKit

protocol HeroesCoordinatorDelegate: class {
    func didLogout(heroesCoordinator: HeroesCoordinator)
}

class HeroesCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator? = nil
    
    var coordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    var rootViewController: UIViewController?
    
    weak var delegate: HeroesCoordinatorDelegate?

    let storyboard = UIStoryboard(name:"Heroes", bundle:nil)
    
    init(parentCoordinator: Coordinator, navigationController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func start(animated: Bool) {
        self.rootViewController = self.heroesViewController(HeroesViewModel())
        self.navigationController.pushViewController(self.rootViewController!, animated: animated)
    }
    
    func stop(animated: Bool) {
        guard let rootViewController = self.rootViewController else { return }
        self.navigationController.popToViewController(rootViewController, animated: false)
        self.navigationController.popViewController(animated: animated)
    }

}

extension HeroesCoordinator: HeroesViewControllerDelegate {
    
    func heroesViewController(_ heroesViewModel: HeroesViewModel) -> HeroesViewController {
        let heroesViewController: HeroesViewController = self.storyboard.instantiateViewController()
        heroesViewController.delegate = self
        heroesViewController.heroesViewModel = heroesViewModel
        return heroesViewController
    }

    func heroesViewController(_ heroesViewController: HeroesViewController, didSelectTeam team: Team) {
        let heroesViewModel = HeroesViewModel()
        heroesViewModel.teamFilter = team
        let heroesViewController = self.heroesViewController(heroesViewModel)
        self.navigationController.pushViewController(heroesViewController, animated: true)
    }
    
    func heroesViewController(_ heroesViewController: HeroesViewController, didSelectHero hero: Hero) {
        let powersViewController = self.powersViewController(hero: hero)
        self.navigationController.pushViewController(powersViewController, animated: true)
    }
    
}

extension HeroesCoordinator: PowersViewControllerDelegate {
    
    func powersViewController(hero: Hero) -> PowersViewController {
        let powersViewController: PowersViewController = self.storyboard.instantiateViewController()
        powersViewController.delegate = self
        powersViewController.hero = hero
        return powersViewController
    }
    
}




extension HeroesCoordinator: LoginCoordinatorDelegate {
    
    func startLoginCoordinator(animated: Bool) {
        let loginCoordinator = LoginCoordinator(parentCoordinator: self, navigationController: self.navigationController)
        loginCoordinator.delegate = self
        loginCoordinator.start(animated: animated)
        self.coordinators.append(loginCoordinator)
    }
    
    
    func didLogin(loginCoordinator: LoginCoordinator) {
        loginCoordinator.stop(animated: false)
        self.coordinators.removeLast()
    }
    
}
