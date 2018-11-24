//
//  ConversionsModel.swift
//  ReactiveExample
//
//  Created by David Levi on 11/24/18.
//  Copyright © 2018 CodeTank Labs LLC. All rights reserved.
//

import Foundation

enum ConversionType: Int {
	case weight = 0 // Values for weight are stored as grams
	case length = 1 // Values for length are stored as meters
}

class ConversionsModel {

	static let shared = ConversionsModel();

	let kConversionsType = "conversions.type"
	let kConversionsWeight = "conversions.weight"
	let kConversionsLength = "conversions.length"

	var type: ConversionType {
		get {
			return ConversionType(rawValue: UserDefaults.standard.integer(forKey: kConversionsType)) ?? .weight
		}
		set {
			UserDefaults.standard.set(newValue.rawValue, forKey: kConversionsType)
		}
	}

	var weight: Double {
		get {
			return UserDefaults.standard.double(forKey: kConversionsWeight)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: kConversionsWeight)
		}
	}

	var length: Double {
		get {
			return UserDefaults.standard.double(forKey: kConversionsLength)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: kConversionsLength)
		}
	}

	required init() {
		UserDefaults.standard.register(defaults: [
			kConversionsType: ConversionType.weight.rawValue,
			kConversionsWeight: 10.0,
			kConversionsLength: 10.0
			])
	}

}
