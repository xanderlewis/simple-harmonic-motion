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
    
    @IBOutlet weak var contentView1: UIView!
    @IBOutlet weak var contentView2: UIView!
    @IBOutlet weak var contentView3: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Be notified when app colour scheme changes
        NotificationCenter.default.addObserver(self, selector: #selector(updateColours), name: AppColourScheme.changed, object: nil)
        
        // Restore previous state (if it exists) for dark theme switch
        if let darkThemeWasOn = UserDefaults.standard.object(forKey: "darkThemeOn") as? Bool {
            if darkThemeWasOn {
                darkThemeSwitch.setOn(true, animated: false)
            } else {
                darkThemeSwitch.setOn(false, animated: false)
            }
        }
        
        updateColours()
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
            
            self.contentView1.backgroundColor = AppColourScheme.shared.colourForTableViewCellBackground()
            self.contentView2.backgroundColor = AppColourScheme.shared.colourForTableViewCellBackground()
            self.contentView3.backgroundColor = AppColourScheme.shared.colourForTableViewCellBackground()
            
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
        
        // Save state to user defaults
        UserDefaults.standard.set(sender.isOn, forKey: "darkThemeOn")
    }
}
