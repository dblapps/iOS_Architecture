//
//  UIView+Ext.swift
//  ReactiveExample
//
//  Created by David Levi on 1/27/19.
//  Copyright © 2019 CodeTank Labs LLC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIView {

	@IBInspectable
	var borderWidth: CGFloat {
		get {
			return self.layer.borderWidth
		}
		set {
			self.layer.borderWidth = newValue
		}
	}

	@IBInspectable
	var borderColor: UIColor? {
		get {
			guard let cgColor = self.layer.borderColor else { return nil }
			return UIColor.init(cgColor: cgColor)
		}
		set {
			if let color = newValue {
				self.layer.borderColor = color.cgColor
			} else {
				self.layer.borderColor = nil
			}
		}
	}

	@IBInspectable
	var cornerRadius: CGFloat {
		get {
			return self.layer.cornerRadius
		}
		set {
			self.layer.cornerRadius = newValue
		}
	}

}

extension Reactive where Base: UIView {

	public var borderWidth: Binder<CGFloat> {
		return Binder(self.base) { view, borderWidth in
			view.borderWidth = borderWidth
		}
	}

	public var borderColor: Binder<UIColor?> {
		return Binder(self.base) { view, borderColor in
			view.borderColor = borderColor
		}
	}

	public var cornerRadius: Binder<CGFloat> {
		return Binder(self.base) { view, cornerRadius in
			view.cornerRadius = cornerRadius
		}
	}

}
