//
//  Powers.swift
//  MVVMExample
//
//  Created by Claudia Levi on 7/29/18.
//  Copyright © 2018 CodeTank Labs LLC. All rights reserved.
//

import Foundation

class Power: Equatable, Comparable, Hashable {
    
    var name: String // name of this power
    var desc: String // description of this power, what does it do
    
    required init(name: String, desc: String) {
        self.name = name
        self.desc = desc
    }
    
    static func == (lhs: Power, rhs: Power) -> Bool {
        return lhs.name == rhs.name
    }

    static func < (lhs: Power, rhs: Power) -> Bool {
        return lhs.name < rhs.name
    }

    var hashValue: Int {
        get {
            return self.name.hashValue
        }
    }

}

class Powers {
    
    static let shared = Powers()

    var powers: [Power]
    var powersIndex: [String:Power] = [:]
    
    required init() {
        self.powers = [
            Power(name: "Super Strength", desc: "Strength beyond normal humans"),
            Power(name: "Wall Climbing", desc: "Climb and cling to vertical surfaces"),
            Power(name: "Web Slinging", desc: "Create and manipulate sticky spider-like webs"),
            Power(name: "Sense Danger", desc: "Sense nearby impending danger"),
            Power(name: "Flying", desc: "Flying through the air, or possibly even into outer-space"),
            Power(name: "Energy Blasts", desc: "Shoot blasts of energy"),
            Power(name: "Super Intelligence", desc: "Intelligence beyond that of ordinary humans."),
            Power(name: "Lightning", desc: "Control and create bolts of lightning"),
            Power(name: "Adamantite Claws", desc: "Super strong and sharp claws made of adamantite metal"),
            Power(name: "Super Healing", desc: "Healing at an incredible rate")
        ]
        self.indexPowers()
    }
    
    private func indexPowers() {
        self.powersIndex = [:]
        _ = self.powers.map { self.powersIndex[$0.name] = $0 }
    }
    
    func create(name: String, desc: String) -> Power {
        let power = Power(name: name, desc: desc)
        powers.append(power)
        powersIndex[power.name] = power
        return power
    }
    
    func delete(power: Power) {
        self.powers = self.powers.filter { $0 != power }
        self.powersIndex[power.name] = nil
    }

    func power(withName name: String) -> Power? {
        return powersIndex[name]
    }

}
