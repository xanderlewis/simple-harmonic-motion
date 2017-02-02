//
//  OptionsTableViewController.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 01/02/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit

class OptionsTableViewController: UITableViewController {
    @IBOutlet weak var motionTrailsSwitch: UISwitch!
    @IBOutlet weak var trailSpeedSwitch: UISegmentedControl!
    
    @IBOutlet weak var darkThemeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Restore user defaults
        let defaults = UserDefaults.standard
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func motionTrailsSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            DefaultSimulationConstants.trailsEnabled = true
        } else {
            DefaultSimulationConstants.trailsEnabled = false
        }
    }
    
    @IBAction func trailSpeedSwitchChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            DefaultSimulationConstants.trailVelocity = 1.5
        case 1:
            DefaultSimulationConstants.trailVelocity = 2.5
        case 2:
            DefaultSimulationConstants.trailVelocity = 6
        default:
            DefaultSimulationConstants.trailVelocity = 2.5
        }
    }
    
    @IBAction func darkThemeSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            // enable dark theme!
        } else {
            // disable dark theme!
        }
    }
}
