//
//  ConversionsViewController.swift
//  ReactiveExample
//
//  Created by David Levi on 11/24/18.
//  Copyright © 2018 CodeTank Labs LLC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

func ignoreEmptyString(string: String?) -> Observable<String> {
	guard let string = string else { return Observable.empty() }
	return string.isEmpty ? Observable.empty() : Observable.just(string)
}

class ConversionsViewController: UIViewController {


	@IBOutlet weak var typeSelector: UISegmentedControl!

	@IBOutlet weak var weightView: UIView!
	@IBOutlet weak var gramsTextField: UITextField!
	@IBOutlet weak var milligramsTextField: UITextField!
	@IBOutlet weak var ouncesTextField: UITextField!

	@IBOutlet weak var lengthView: UIView!
	@IBOutlet weak var metersTextField: UITextField!
	@IBOutlet weak var centimetersTextField: UITextField!
	@IBOutlet weak var millimetersTextField: UITextField!
	@IBOutlet weak var inchesTextField: UITextField!

	var conversionsViewModel: ConversionsViewModel? = nil {
		didSet {
			self.bindModel()
		}
	}

	var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
		self.bindModel()

		self.gramsTextField.delegate = self
		self.milligramsTextField.delegate = self
		self.ouncesTextField.delegate = self
		self.metersTextField.delegate = self
		self.centimetersTextField.delegate = self
		self.millimetersTextField.delegate = self
		self.inchesTextField.delegate = self
    }

	private func bindModel() {

		let l = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
		l.rx.text

		// Make sure we have a model to bind to
		guard let model = self.conversionsViewModel else { return }

		// Make sure our views are loaded so we kind bind to them
		guard self.viewIfLoaded != nil else { return }

		// Get rid of any old subscriptions in case our model has been changed
		self.disposeBag = DisposeBag()

		// Bind typeSelector to view model's type
		model.type.asDriver(onErrorJustReturn: .weight)
			.map({$0.rawValue})
			.drive(self.typeSelector.rx.selectedSegmentIndex)
			.disposed(by: self.disposeBag)
		self.typeSelector.rx.selectedSegmentIndex
			.map({ConversionType(rawValue: $0)!})
			.asObservable().bind(to: model.type)
			.disposed(by: self.disposeBag)

		// Bind weightView's visibility to view model's type
		model.type.asDriver(onErrorJustReturn: .weight)
			.map({$0 != .weight})
			.drive(self.weightView.rx.isHidden)
			.disposed(by: self.disposeBag)

		// Bind lengthView's visibility to view model's type
		model.type.asDriver(onErrorJustReturn: .weight)
			.map({$0 != .length})
			.drive(self.lengthView.rx.isHidden)
			.disposed(by: self.disposeBag)

		let bindings: [(textField: UITextField, subject: Any)] = [
			(self.gramsTextField, model.grams),
			(self.milligramsTextField, model.milligrams),
			(self.ouncesTextField, model.ounces),
			(self.metersTextField, model.meters),
			(self.centimetersTextField, model.centimeters),
			(self.millimetersTextField, model.millimeters),
			(self.inchesTextField, model.inches)
		]
		bindings.forEach { (textField, subject) in
			if let observable = subject as? Observable<Double> {
			observable
				.distinctUntilChanged()
				.filter{ str -> Bool in !textField.isFirstResponder }
				.asDriver(onErrorJustReturn: 0.0)
				.map({"\($0)"})
				.drive(textField.rx.text)
				.disposed(by: self.disposeBag)
			}
			if let observer = subject as? BehaviorSubject<Double> {
				textField.rx.text.orEmpty
					.distinctUntilChanged()
					.flatMap(ignoreEmptyString)
					.map({Double($0) ?? 0.0})
					.asDriver(onErrorJustReturn: 0.0)
					.drive(observer)
					.disposed(by: self.disposeBag)
			}
			if let observer = subject as? PublishSubject<Double> {
				textField.rx.text.orEmpty
					.distinctUntilChanged()
					.flatMap(ignoreEmptyString)
					.map({Double($0) ?? 0.0})
					.asDriver(onErrorJustReturn: 0.0)
					.drive(observer)
					.disposed(by: self.disposeBag)
			}
		}

	}

}

extension ConversionsViewController: UITextFieldDelegate {

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let decimalPoint = CharacterSet(charactersIn: ".")
		let nonDecimals = CharacterSet.decimalDigits.inverted.subtracting(decimalPoint)
		if let _ = string.rangeOfCharacter(from: nonDecimals) {
			return false
		}
		if let _ = string.rangeOfCharacter(from: decimalPoint), let _ = textField.text?.rangeOfCharacter(from: decimalPoint) {
			return false
		}
		return true
	}

}
