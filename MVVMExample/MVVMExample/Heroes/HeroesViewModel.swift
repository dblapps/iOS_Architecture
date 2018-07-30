//
//  HeroesViewModel.swift
//  MVVMExample
//
//  Created by Claudia Levi on 7/29/18.
//  Copyright © 2018 CodeTank Labs LLC. All rights reserved.
//

import Foundation

class HeroesViewModel {
    
    var teams: [Team] = []
    var heroes: [Hero] = []
    
    var universeFilter: Universe? = nil {
        didSet {
            self.applyFilters()
        }
    }
    var teamFilter: Team? = nil {
        didSet {
            self.applyFilters()
        }
    }
    
    required init() {
        self.teams = Teams.shared.teams.sorted { $0 < $1 }
        self.heroes = Heroes.shared.heroes.sorted { $0 < $1 }
    }

    private func applyFilters() {
        if let teamFilter = self.teamFilter {
            self.teams = [teamFilter]
            self.heroes = Array(teamFilter.heroes)
        } else {
            self.teams = Teams.shared.teams
            self.heroes = Heroes.shared.heroes
        }
        if let universeFilter = self.universeFilter {
            self.teams = self.teams.filter { $0.universes.contains(universeFilter) }
            self.heroes = self.heroes.filter { $0.universe == universeFilter }
        }
        self.teams = self.teams.sorted { $0 < $1 }
        self.heroes = self.heroes.sorted { $0 < $1 }
    }
    
}
