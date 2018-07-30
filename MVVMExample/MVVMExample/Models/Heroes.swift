//
//  Heroes.swift
//  MVVMExample
//
//  Created by Claudia Levi on 7/29/18.
//  Copyright © 2018 CodeTank Labs LLC. All rights reserved.
//

import Foundation

enum Universe: String {
    case Marvel = "Marvel"
    case DC = "DC"
}

class Hero: Equatable, Comparable, Hashable {
    
    var name: String
    var universe: Universe
    var powers: Set<Power> = Set<Power>()

    required init(name: String, universe: Universe) {
        self.name = name
        self.universe = universe
    }
    
    static func == (lhs: Hero, rhs: Hero) -> Bool {
        return lhs.name == rhs.name
    }

    static func < (lhs: Hero, rhs: Hero) -> Bool {
        return lhs.name < rhs.name
    }

    var hashValue: Int {
        get {
            return self.name.hashValue
        }
    }

    func add(power: Power) {
        powers.insert(power)
    }
    
    func add(powers: [Power]) {
        _ = powers.map { self.add(power: $0) }
    }
    
    func remove(power: Power) {
        powers.remove(power)
    }
    
    func remove(powers: [Power]) {
        _ = powers.map { self.remove(power: $0) }
    }

}

class Heroes {

    static let shared = Heroes()

    var heroes: [Hero]
    var heroesIndex: [String:Hero] = [:]
    
    required init() {
        let spiderman = Hero(name: "Spiderman", universe: .Marvel)
        spiderman.add(powers: [
            Powers.shared.power(withName: "Super Strength"),
            Powers.shared.power(withName: "Wall Climbing"),
            Powers.shared.power(withName: "Web Slinging"),
            Powers.shared.power(withName: "Sense Danger")
            ].compactMap { $0 })

        let ironman = Hero(name: "Ironman", universe: .Marvel)
        ironman.add(powers: [
            Powers.shared.power(withName: "Flying"),
            Powers.shared.power(withName: "Super Strength"),
            Powers.shared.power(withName: "Energy Blasts"),
            Powers.shared.power(withName: "Super Intelligence")
            ].compactMap { $0 })

        let thor = Hero(name: "Thor", universe: .Marvel)
        thor.add(powers: [
            Powers.shared.power(withName: "Super Strength"),
            Powers.shared.power(withName: "Lightning"),
            Powers.shared.power(withName: "Flying")
        ].compactMap { $0 })

        let wolverine = Hero(name: "Wolverine", universe: .Marvel)
        wolverine.add(powers: [
            Powers.shared.power(withName: "Super Strength"),
            Powers.shared.power(withName: "Adamantite Claws"),
            Powers.shared.power(withName: "Super Healing")
        ].compactMap { $0 })

        self.heroes = [
            spiderman,
            ironman,
            thor,
            wolverine
        ]
        self.indexHeroes()
    }
    
    private func indexHeroes() {
        self.heroesIndex = [:]
        _ = self.heroes.map { self.heroesIndex[$0.name] = $0 }
    }

    func create(name: String, universe: Universe, powers: [Power]) -> Hero {
        let hero = Hero(name: name, universe: universe)
        hero.add(powers: powers)
        heroes.append(hero)
        self.heroesIndex[hero.name] = hero
        return hero
    }
    
    func delete(hero: Hero) {
        self.heroes = self.heroes.filter { $0 != hero }
        self.heroesIndex[hero.name] = nil
    }
    
    func hero(withName name: String) -> Hero? {
        return heroesIndex[name]
    }

}
