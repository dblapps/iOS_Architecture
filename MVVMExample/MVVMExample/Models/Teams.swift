//
//  Teams.swift
//  MVVMExample
//
//  Created by Claudia Levi on 7/29/18.
//  Copyright © 2018 CodeTank Labs LLC. All rights reserved.
//

import Foundation

class Team: Equatable, Comparable, Hashable {
    
    var name: String
    var heroes: Set<Hero> = Set<Hero>()

    required init(_ name: String) {
        self.name = name
    }

    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.name == rhs.name
    }

    static func < (lhs: Team, rhs: Team) -> Bool {
        return lhs.name < rhs.name
    }

    var hashValue: Int {
        get {
            return self.name.hashValue
        }
    }

    func add(hero: Hero) {
        heroes.insert(hero)
    }
    
    func add(heroes: [Hero]) {
        _ = heroes.map { self.add(hero: $0) }
    }
    
    func remove(hero: Hero) {
        heroes.remove(hero)
    }
    
    func remove(heroes: [Hero]) {
        _ = heroes.map { self.remove(hero: $0) }
    }

    var universes: Set<Universe> {
        get {
            var universes = Set<Universe>()
            if self.heroes.reduce(false, { $1.universe == .Marvel ? true : $0 }) {
                universes.insert(.Marvel)
            }
            if self.heroes.reduce(false, { $1.universe == .DC ? true : $0 }) {
                universes.insert(.DC)
            }
            return universes
        }
    }
    
}

class Teams {
    
    static let shared = Teams()

    var teams: [Team]
    var teamsIndex: [String:Team] = [:]

    required init() {
        let avengers = Team("The Avengers")
        avengers.add(heroes: [
            Heroes.shared.hero(withName: "Ironman"),
            Heroes.shared.hero(withName: "Thor")
            ].compactMap { $0 })

        let xmen = Team("X-Men")
        xmen.add(heroes: [
            Heroes.shared.hero(withName: "Wolverine")
            ].compactMap { $0 })

        let fantasticFour = Team("Fantastic Four")

        let justiceLeague = Team("Justice League")

        let suicideSquad = Team("Suicide Squad")

        self.teams = [
            avengers,
            xmen,
            fantasticFour,
            justiceLeague,
            suicideSquad
        ]
        self.indexTeams()
    }
    
    private func indexTeams() {
        self.teamsIndex = [:]
        _ = self.teams.map { self.teamsIndex[$0.name] = $0 }
    }

    func create(name: String) -> Team {
        let team = Team(name)
        teams.append(team)
        self.teamsIndex[team.name] = team
        return team
    }
    
    func delete(team: Team) {
        teams = self.teams.filter { $0 != team }
        self.teamsIndex[team.name] = nil
    }
    
}
