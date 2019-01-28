//
//  ConversionsViewModel.swift
//  ReactiveExample
//
//  Created by David Levi on 11/24/18.
//  Copyright © 2018 CodeTank Labs LLC. All rights reserved.
//

import Foundation
import RxSwift

class ConversionsViewModel {

	private(set) lazy var type = BehaviorSubject<ConversionType>(value: self.conversionsModel.type)

	private(set) lazy var grams = BehaviorSubject<Double>(value: self.conversionsModel.weight)
	let milligrams = PublishSubject<Double>()
	let ounces = PublishSubject<Double>()

	private(set) lazy var meters = BehaviorSubject<Double>(value: self.conversionsModel.length)
	let centimeters = PublishSubject<Double>()
	let millimeters = PublishSubject<Double>()
	let inches = PublishSubject<Double>()

	let disposeBag = DisposeBag()

	var conversionsModel: ConversionsModel

	required init(_ conversionsModel: ConversionsModel) {

		self.conversionsModel = conversionsModel


		// Setup subscriptions for updating the conversions model

		self.type.asObservable().subscribe(onNext: { [unowned self] (type) in
			self.conversionsModel.type = type
		}).disposed(by: self.disposeBag)

		self.grams.asObservable().subscribe(onNext: { [unowned self] (grams) in
			self.conversionsModel.weight = grams
		}).disposed(by: self.disposeBag)

		self.meters.asObservable().subscribe(onNext: { [unowned self] (meters) in
			self.conversionsModel.length = meters
		}).disposed(by: self.disposeBag)

		
		// Setup subscriptions for performing conversions

		let conversions: [(from: BehaviorSubject<Double>, to: PublishSubject<Double>, factor: Double)] = [
			(self.grams, self.milligrams, 1000.0),
			(self.grams, self.ounces, 0.035274),
			(self.meters, self.centimeters, 100.0),
			(self.meters, self.millimeters, 1000.0),
			(self.meters, self.inches, 39.3701)
		]
		conversions.forEach { (from, to, factor) in
			from
				.distinctUntilChanged()
				.map({$0 * factor})
				.observeOn(MainScheduler.asyncInstance)
				.bind(to: to)
				.disposed(by: self.disposeBag)
			to
				.distinctUntilChanged()
				.map({$0 / factor})
				.observeOn(MainScheduler.asyncInstance)
				.bind(to: from)
				.disposed(by: self.disposeBag)
		}

	}

}
