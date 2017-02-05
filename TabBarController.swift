//
//  TabBarController.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 01/02/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var newRecordings = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get reference to all views in tab bar (helps with performance)
        for viewController in viewControllers! {
            let _ = viewController.view!
        }
        
        // Be notified when app colour scheme changes
        NotificationCenter.default.addObserver(self, selector: #selector(updateColours), name: AppColourScheme.changed, object: nil)
        
        updateColours()
        
        for item in tabBar.items! {
            if #available(iOS 10.0, *) {
                item.badgeColor = UIColor(red:1.00, green:0.00, blue:0.36, alpha:1.0)
            }
        }
    }
    
    func incrementNewRecordings() {
        newRecordings += 1
        tabBar.items?[1].badgeValue = String(newRecordings)
    }
    
    func clearNewRecordings() {
        newRecordings = 0
        tabBar.items?[1].badgeValue = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateColours() {
        tabBar.barStyle = AppColourScheme.shared.styleForTabBar()
    }
}
