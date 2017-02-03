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
    
    @IBOutlet weak var motionTrailsLabel: UILabel!
    @IBOutlet weak var trailSpeedLabel: UILabel!
    @IBOutlet weak var darkThemeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Be notified when app colour scheme changes
        NotificationCenter.default.addObserver(self, selector: #selector(updateColours), name: AppColourScheme.changed, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateColours() {
        
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.tableView.backgroundColor = AppColourScheme.shared.colourForTableViewBackground()
            self.tableView.separatorColor = AppColourScheme.shared.colourForTableViewSeparator()
            self.tableView.sectionIndexColor = AppColourScheme.shared.colourForTableViewText()
            
            for cell in self.tableView.visibleCells {
                cell.contentView.backgroundColor = AppColourScheme.shared.colourForTableViewCellBackground()
            }
            
            self.motionTrailsSwitch.tintColor = AppColourScheme.shared.colourForUIElementTint()
            self.trailSpeedSwitch.tintColor = AppColourScheme.shared.colourForUIElementTint()
            self.darkThemeSwitch.tintColor = AppColourScheme.shared.colourForUIElementTint()
            
            self.motionTrailsLabel.textColor = AppColourScheme.shared.colourForTableViewText()
            self.trailSpeedLabel.textColor = AppColourScheme.shared.colourForTableViewText()
            self.darkThemeLabel.textColor = AppColourScheme.shared.colourForTableViewText()

        }, completion: nil)
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
            // Enable dark theme
            AppColourScheme.shared.current = .dark
        } else {
            // Disable dark theme
            AppColourScheme.shared.current = .light
        }
    }
}
