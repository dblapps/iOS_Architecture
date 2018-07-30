//
//  PowersViewController.swift
//  CoordinatorsExample
//
//  Created by David Levi on 5/20/18.
//  Copyright © 2018 CodeTank Labs LLC. All rights reserved.
//

import UIKit

protocol PowersViewControllerDelegate: class {
}

class PowersViewController: UIViewController {

    weak var delegate: PowersViewControllerDelegate? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    var hero: Hero? = nil {
        didSet {
            if let hero = self.hero {
                self.powers = Array(hero.powers).sorted { $0 < $1 }
            } else {
                self.powers = []
            }
            self.tableView?.reloadData()
        }
    }

    var powers: [Power] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension PowersViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hero?.powers.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PowerCellID", for: indexPath)
        if self.powers.count == 0 {
            cell.textLabel?.text = "No Powers"
        } else {
            cell.textLabel?.text = self.powers[indexPath.row].name
            cell.detailTextLabel?.text = self.powers[indexPath.row].desc
        }
        return cell
    }
    
    
}

extension PowersViewController: UITableViewDelegate {
    
}
