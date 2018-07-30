//
//  HeroesViewController.swift
//  CoordinatorsExample
//
//  Created by David Levi on 5/20/18.
//  Copyright © 2018 CodeTank Labs LLC. All rights reserved.
//

import UIKit

protocol HeroesViewControllerDelegate: class {
    func heroesViewController(_ heroesViewController: HeroesViewController, didSelectTeam team: Team)
    func heroesViewController(_ heroesViewController: HeroesViewController, didSelectHero hero: Hero)
}

class HeroesViewController: UIViewController {

    weak var delegate: HeroesViewControllerDelegate? = nil

    var heroesViewModel: HeroesViewModel! {
        didSet {
            self.tableView?.reloadData()
            if self.heroesViewModel.teamFilter == nil {
                self.navigationItem.hidesBackButton = true
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var filterButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.filterButton
    }

    @IBAction func filter(_ sender: Any) {
        let alert = UIAlertController(title: "Filter", message: "Select comics universe", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "None", style: .default, handler: { action in
            self.heroesViewModel.universeFilter = nil
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Marvel", style: .default, handler: { action in
            self.heroesViewModel.universeFilter = .Marvel
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "DC", style: .default, handler: { action in
            self.heroesViewModel.universeFilter = .DC
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension HeroesViewController: UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let heroesViewModel = self.heroesViewModel else { return 0 }
        return heroesViewModel.teams.count <= 1 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.heroesViewModel.teams.count <= 1 {
            return self.heroesViewModel.heroes.count > 0 ? self.heroesViewModel.heroes.count : 1
        }
        if section == 0 {
            return self.heroesViewModel.teams.count
        }
        return self.heroesViewModel.heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeroCellID", for: indexPath)
        cell.textLabel?.textColor = .black
        cell.detailTextLabel?.text = ""
        cell.detailTextLabel?.textColor = .lightGray
        if self.heroesViewModel.teams.count <= 1 {
            if self.heroesViewModel.heroes.count > 0 {
                cell.textLabel?.text = self.heroesViewModel.heroes[indexPath.row].name
                cell.detailTextLabel?.text = self.heroesViewModel.heroes[indexPath.row].universe.rawValue
            } else {
                cell.textLabel?.text = "No Heroes"
                cell.textLabel?.textColor = .lightGray
            }
        } else if indexPath.section == 0 {
            cell.textLabel?.text = self.heroesViewModel.teams[indexPath.row].name
        } else {
            cell.textLabel?.text = self.heroesViewModel.heroes[indexPath.row].name
            cell.detailTextLabel?.text = self.heroesViewModel.heroes[indexPath.row].universe.rawValue
        }
        return cell
    }
    
}

extension HeroesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.heroesViewModel.teams.count == 0 {
            return nil
        }
        if self.heroesViewModel.teams.count == 1 {
            return self.heroesViewModel.teams[0].name
        }
        if section == 0 {
            return "Teams"
        }
        return "Heroes"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.heroesViewModel.teams.count <= 1 {
            if self.heroesViewModel.heroes.count > 0 {
                self.delegate?.heroesViewController(self, didSelectHero: self.heroesViewModel.heroes[indexPath.row])
            }
        } else if indexPath.section == 0 {
            self.delegate?.heroesViewController(self, didSelectTeam: self.heroesViewModel.teams[indexPath.row])
        } else {
            self.delegate?.heroesViewController(self, didSelectHero: self.heroesViewModel.heroes[indexPath.row])
        }
    }

}
