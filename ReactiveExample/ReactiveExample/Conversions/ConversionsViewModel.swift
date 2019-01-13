//
//  ConversionsViewModel.swift
//  ReactiveExample
//
//  Created by David Levi on 11/24/18.
//  Copyright © 2018 CodeTank Labs LLC. All rights reserved.
//

import Foundation
import RxSwift

func performBlock(_ block: @escaping () -> Void)
{
	DispatchQueue.main.async(execute: block);
}

func performBlockAndWait(_ block: @escaping () -> Void)
{
	DispatchQueue.main.sync(execute: block);
}

func performDelayedBlock(_ delay: TimeInterval, _ block: @escaping () -> Void)
{
	DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: block)
}

func performBgBlock(_ block: @escaping () -> Void)
{
	DispatchQueue.global(qos: .background).async(execute: block);
}

func performBgBlockAndWait(_ block: @escaping () -> Void)
{
	DispatchQueue.global(qos: .background).sync(execute: block);
}

func performDelayedBgBlock(_ delay: TimeInterval, _ block: @escaping () -> Void)
{
	DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + delay, execute: block)
}

class ConversionsViewModel {

//	let type = Variable<ConversionType>(.weight)
	let type = PublishSubject<ConversionType>()

	let grams = PublishSubject<Double>()
	let milligrams = PublishSubject<Double>()
	let ounces = PublishSubject<Double>()

	let meters = PublishSubject<Double>()
	let centimeters = PublishSubject<Double>()
	let millimeters = PublishSubject<Double>()
	let inches = PublishSubject<Double>()

	let disposeBag = DisposeBag()

	var conversionsModel: ConversionsModel

	required init(_ conversionsModel: ConversionsModel) {

		self.conversionsModel = conversionsModel

		// Get initial values from model

//		self.type.value = conversionsModel.type

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

		let conversions: [(from: PublishSubject<Double>, to: PublishSubject<Double>, factor: Double)] = [
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

		// Get initial values from model
		self.type.onNext(conversionsModel.type)
		self.grams.onNext(conversionsModel.weight)
		self.meters.onNext(conversionsModel.length)

	}

}
