//
//  ViewController.swift
//  ReactiveExample
//
//  Created by David Levi on 11/23/18.
//  Copyright © 2018 CodeTank Labs LLC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

//	let disposeBag = DisposeBag()

	var obsvar: Observable<Int>? = nil
	var subvar1: Disposable? = nil
	var subvar2: Disposable? = nil

	override func viewDidLoad() {
		super.viewDidLoad()

		rxcocoa_example_2()
	}

	/************************************************************************************************
	 *	EXAMPLE 1
	 ************************************************************************************************/
	func example_1() {
		let observable = Observable<Int>.create { observer -> Disposable in
			[1, 1, 2, 3, 5, 8, 13, 21, 34].forEach { observer.onNext($0) }
			observer.onCompleted()
			return Disposables.create()
		}

		_ = observable.subscribe(onNext: { (value) in
			print("Value: \(value)")
		}, onCompleted: {
			print("Completed")
		})
	}

	/************************************************************************************************
	 *	EXAMPLE 2
	 ************************************************************************************************/
	func example_2() {
		let observable = Observable<Int>.create { observer -> Disposable in
			performBgBlock {
				[1, 1, 2, 3, 5, 8, 13, 21, 34].forEach {
					Thread.sleep(forTimeInterval: 1.0)
					observer.onNext($0)
				}
				observer.onCompleted()
			}
			return Disposables.create()
		}

		_ = observable.subscribe(onNext: { (value) in
			print("Value: \(value)")
		}, onCompleted: {
			print("Completed")
		})
	}

	/************************************************************************************************
	 *	EXAMPLE 3
	 ************************************************************************************************/
	func example_3() {
		let observable = Observable<Int>.from([1, 1, 2, 3, 5, 8, 13, 21, 34])

		_ = observable.subscribe(onNext: { (value) in
			print("Value: \(value)")
		}, onCompleted: {
			print("Completed")
		})
	}

	/************************************************************************************************
	 *	EXAMPLE 4
	 ************************************************************************************************/
	func example_4() {
		let observable = Observable<Int>.just(5)

		_ = observable.subscribe(onNext: { (value) in
			print("Value: \(value)")
		}, onCompleted: {
			print("Completed")
		})
	}

	/************************************************************************************************
	 *	EXAMPLE 5
	 ************************************************************************************************/
	func example_5() {
		let observable = Observable<Any>.create { observer -> Disposable in
			let session = URLSession.shared
			let task = session.dataTask(with: URL(string:"https://pokeapi.co/api/v2/pokemon/1")!, completionHandler: { (data, response, error) in
				if let err = error {
					observer.onError(err)
				} else if let data = data {
					if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
						observer.onNext(json)
						observer.onCompleted()
					} else {
						observer.onError(NSError(domain: "com.codetanklabs.errorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey:"JSON parse error"]))
					}
				} else {
					observer.onError(NSError(domain: "com.codetanklabs.errorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey:"No data returned from request"]))
				}
			})

			task.resume()

			return Disposables.create {
				//Cancel the connection if disposed
				task.cancel()
			}
		}

		_ = observable.subscribe(onNext: { (json) in
			print("RESPONSE:\n\(json)")
		}, onError: { (error) in
			print("ERROR: \(error)")
		}, onCompleted: {
			print("COMPLETED")
		})
	}

	/************************************************************************************************
	 *	EXAMPLE 6
	 ************************************************************************************************/
	func example_6() {
		print("---------------------------------------\nObservable never completes, do not dispose Disposable:")
		memory_management_example_manual(completeSequence: false, disposeDisposable: false)
		print("---------------------------------------\nObservable completes, do not dispose Disposable:")
		memory_management_example_manual(completeSequence: true, disposeDisposable: false)
		print("---------------------------------------\nObservable never completes, dispose Disposable manually:")
		memory_management_example_manual(completeSequence: false, disposeDisposable: true)
		print("---------------------------------------\nObservable completes, dispose Disposable manually:")
		memory_management_example_manual(completeSequence: true, disposeDisposable: true)
		print("---------------------------------------\nObservable completes, dispose Disposable using DisposeBag:")
		memory_management_example_bag()
	}

	func memory_management_example_manual(completeSequence: Bool, disposeDisposable: Bool) {
		let initialResourceCount = RxSwift.Resources.total
		print("Initial Resource Count: \(initialResourceCount)")

		var obs: Observable<Int>? = Observable<Int>.create { observer in
			[1, 2, 3].forEach { observer.onNext($0) }
			if completeSequence { observer.onCompleted() }
			return Disposables.create()
		}

		print("Resource count delta after creating Observable: \(RxSwift.Resources.total - initialResourceCount)")

		var sub: Disposable? = obs?.subscribe(onNext: { val in
			print("Value: \(val)")
		}, onError: { error in
			print("Error: \(error)")
		}, onCompleted: {
			print("Completed")
		}, onDisposed: {
			print("Disposed")
		})
		print("Resource count delta After All Elements Emitted: \(RxSwift.Resources.total - initialResourceCount)")

		obs = nil
		print("Resource count delta after nil-ing reference to Observable: \(RxSwift.Resources.total - initialResourceCount)")

		if disposeDisposable {
			sub?.dispose()
			print("Resource count delta after disposing Disposable: \(RxSwift.Resources.total - initialResourceCount)")
		}

		sub = nil
		print("Resource count delta after nil-ing reference to Disposable: \(RxSwift.Resources.total - initialResourceCount)")
	}

	func memory_management_example_bag() {
		let initialResourceCount = RxSwift.Resources.total
		print("Initial Resource Count: \(initialResourceCount)")

		var obs: Observable<Int>? = Observable<Int>.create { observer in
			[1, 2, 3].forEach { observer.onNext($0) }
			observer.onCompleted()
			return Disposables.create()
		}

		print("Resource count delta after creating Observable: \(RxSwift.Resources.total - initialResourceCount)")

		var disposeBag: DisposeBag? = DisposeBag()

		obs?.subscribe(onNext: { val in
			print("Value: \(val)")
		}, onError: { error in
			print("Error: \(error)")
		}, onCompleted: {
			print("Completed")
		}, onDisposed: {
			print("Disposed")
		}).disposed(by: disposeBag!)
		print("Resource count delta After First Subscription: \(RxSwift.Resources.total - initialResourceCount)")

		obs?.subscribe(onNext: { val in
			print("Value: \(val)")
		}, onError: { error in
			print("Error: \(error)")
		}, onCompleted: {
			print("Completed")
		}, onDisposed: {
			print("Disposed")
		}).disposed(by: disposeBag!)
		print("Resource count delta After Second Subscription: \(RxSwift.Resources.total - initialResourceCount)")

		obs = nil
		print("Resource count delta after nil-ing reference to Observable: \(RxSwift.Resources.total - initialResourceCount)")

		disposeBag = nil
		print("Resource count delta after nil-ing DisposeBag: \(RxSwift.Resources.total - initialResourceCount)")
	}

	/************************************************************************************************
	 *	EXAMPLE 7
	 ************************************************************************************************/
	func example_7() {
		let observable = Observable<Int>.from([1, 1, 2, 3, 5, 8, 13, 21, 34])

		let transformedObservable = observable.map { value in
			return value * 10
		}

		_ = transformedObservable.subscribe(onNext: { (value) in
			print("Value: \(value)")
		}, onCompleted: {
			print("Completed")
		})
	}

	/************************************************************************************************
	 *	EXAMPLE 8
	 ************************************************************************************************/
	func example_8() {
		/*
		time:			1    1.5  2    2.5  3    3.5  4    4.5  5    5.5  6    6.5  7    7.5  8    8.5  9    9.5
						---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
		observable1:	1         2         3         4         5         6         7         8         9
		observable2:		 A              B              C              D              E
		combined:			 1,A  2,A       2,B       4,B  4,C  5,C       5,D       7,D  7,E  8,E       9,E
											3,B                           6,D
		*/
		let observable1 = Observable<Int>.create { observer -> Disposable in
			performBgBlock {
				[1, 2, 3, 4, 5, 6, 7, 8, 9].forEach {
					Thread.sleep(forTimeInterval: 1.0)
					observer.onNext($0)
				}
				observer.onCompleted()
			}
			return Disposables.create()
		}
		let observable2 = Observable<String>.create { observer -> Disposable in
			performBgBlock {
				["A", "B", "C", "D", "E"].forEach {
					Thread.sleep(forTimeInterval: 1.5)
					observer.onNext($0)
				}
				observer.onCompleted()
			}
			return Disposables.create()
		}

		let combinedObservable = Observable.combineLatest(observable1, observable2)

		_ = combinedObservable.subscribe(onNext: { (tuple) in
			print("Tuple: \(tuple)")
		}, onCompleted: {
			print("Completed")
		})
	}

	/************************************************************************************************
	 *	EXAMPLE 9
	 ************************************************************************************************/
	func example_9() {
		/*
		time:			1    1.5  2    2.5  3    3.5  4    4.5  5    5.5  6    6.5  7    7.5  8    8.5  9    9.5
						---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
		observable1:	1         2         3         4         5         6         7         8         9
		observable2:		 A              B              C              D              E
		combined:			 1,A            2,B            3,C            4,D            5,E
		*/
		let observable1 = Observable<Int>.create { observer -> Disposable in
			performBgBlock {
				[1, 2, 3, 4, 5, 6, 7, 8, 9].forEach {
					Thread.sleep(forTimeInterval: 1.0)
					observer.onNext($0)
				}
				observer.onCompleted()
			}
			return Disposables.create()
		}
		let observable2 = Observable<String>.create { observer -> Disposable in
			performBgBlock {
				["A", "B", "C", "D", "E"].forEach {
					Thread.sleep(forTimeInterval: 1.5)
					observer.onNext($0)
				}
				observer.onCompleted()
			}
			return Disposables.create()
		}

		let combinedObservable = Observable.zip(observable1, observable2)

		_ = combinedObservable.subscribe(onNext: { (tuple) in
			print("Tuple: \(tuple)")
		}, onCompleted: {
			print("Completed")
		})
	}

	/************************************************************************************************
	 *	EXAMPLE 10
	 ************************************************************************************************/
	var getPokemonDisposeBag = DisposeBag()

	func get_pokemon(offset: Int) -> Observable<[String]> {
		return Observable<[String]>.create { [unowned self] observer -> Disposable in
			let session = URLSession.shared
			let task = session.dataTask(with: URL(string:"https://pokeapi.co/api/v2/pokemon?offset=\(offset)&limit=20")!, completionHandler: { [unowned self] (data, response, error) in
				if let err = error {
					observer.onError(err)
				} else if let data = data {
					if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
						let dict = json as? [String:Any]
						let nextUrl = dict?["next"] as? String
						let nextOffset: Int? = (nextUrl == nil) ? nil : offset + 20
						let results = dict?["results"] as? [[String:String]]
						if let names = results?.compactMap({ $0["name"] }) {
							observer.onNext(names)
							if let nextOffset = nextOffset {
								self.get_pokemon(offset: nextOffset).subscribe(onNext: { (names) in
									observer.onNext(names)
								}, onError: { (error) in
									observer.onError(error)
								}, onCompleted: {
									observer.onCompleted()
								}).disposed(by: self.getPokemonDisposeBag)
							} else {
								observer.onCompleted()
							}
						} else {
							observer.onError(NSError(domain: "com.codetanklabs.errorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey:"JSON parse error"]))
						}
					} else {
						observer.onError(NSError(domain: "com.codetanklabs.errorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey:"JSON parse error"]))
					}
				} else {
					observer.onError(NSError(domain: "com.codetanklabs.errorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey:"No data returned from request"]))
				}
			})
			task.resume()
			return Disposables.create { task.cancel() }
		}
	}

	func example_10() {
		let initialResourceCount = RxSwift.Resources.total
		print("Initial Resource Count: \(initialResourceCount)")
		var count = 0
		get_pokemon(offset: 0).observeOn(MainScheduler.asyncInstance).subscribe(onNext: { val in
			val.forEach {
				count = count + 1
				print("Pokemon name: \($0)")
			}
		}, onError: { [unowned self] error in
			self.getPokemonDisposeBag = DisposeBag()
			print("Error: \(error)")
		}, onCompleted: { [unowned self] in
			self.getPokemonDisposeBag = DisposeBag()
			print("Completed, got \(count) Pokemon")
			performDelayedBlock(1.0) {
				print("Final Resource Count, delta: \(RxSwift.Resources.total), \(RxSwift.Resources.total - initialResourceCount)")
			}
		}, onDisposed: {
			print("Disposed")
		}).disposed(by: self.getPokemonDisposeBag)
	}

	/************************************************************************************************
	 *	RxCocoa EXAMPLE 1
	 ************************************************************************************************/

	let disposeBag = DisposeBag()

	@IBOutlet weak var tapMeButton: UIButton!
	@IBOutlet weak var tapCountLabel: UILabel!

	func rxcocoa_example_1() {
		self.tapMeButton.isHidden = false
		self.tapCountLabel.isHidden = false
		self.tapCountLabel.text = "Tap Count:  0"
		self.tapMeButton.rx.tap
			.scan(0) { (tapCount, _) in
				return tapCount + 1
			}
			.map { "Tap Count:  \($0)" }
			.bind(to: self.tapCountLabel.rx.text)
			.disposed(by: self.disposeBag)
	}

	func bgSeq() -> Observable<Int> {
		return Observable<Int>.create { observer in
			performBgBlock {
				observer.onNext(0)
				[1, 2, 3, 4, 5].forEach {
					Thread.sleep(forTimeInterval: 1.0)
					observer.onNext($0)
				}
				observer.onCompleted()
			}
			return Disposables.create()
		}
	}

	/************************************************************************************************
	 *	RxCocoa EXAMPLE 2
	 ************************************************************************************************/
	func rxcocoa_example_2() {
		self.tapMeButton.isHidden = false
		self.tapCountLabel.isHidden = false
		self.tapCountLabel.text = "Nothing emitted yet..."
		self.tapMeButton.rx.tap
			.subscribe(onNext: { value in
				self.tapMeButton.isEnabled = false
				self.bgSeq()
					.observeOn(MainScheduler.asyncInstance)
					.subscribe(onNext: { value in
						self.tapCountLabel.text = "Emitted value is \(value)"
					}, onCompleted: { [unowned self] in
						self.tapMeButton.isEnabled = true
					})
					.disposed(by: self.disposeBag)
			})
			.disposed(by: self.disposeBag)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let conversionsViewController = segue.destination as? ConversionsViewController {
			conversionsViewController.conversionsViewModel = ConversionsViewModel(ConversionsModel.shared)
		}
	}

}
