//
//  ViewController.swift
//  ReactiveExample
//
//  Created by David Levi on 11/23/18.
//  Copyright © 2018 CodeTank Labs LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let conversionsViewController = segue.destination as? ConversionsViewController {
			conversionsViewController.conversionsViewModel = ConversionsViewModel(ConversionsModel.shared)
		}
	}

}

