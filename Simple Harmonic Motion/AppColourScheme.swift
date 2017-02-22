//
//  AppColourscheme.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 03/02/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import Foundation
import UIKit

enum ColourScheme {
    case light
    case dark
}

class AppColourScheme {
    static let shared = AppColourScheme(.dark) // (default colourscheme is dark)
    var current: ColourScheme {
        didSet {
            if current != oldValue {
                // Post notification to indicate that the colour scheme has changed for the whole app
                NotificationCenter.default.post(name: AppColourScheme.changed, object: nil)
            }
        }
    }
    
    // Notification key for colour scheme changes
    static let changed = NSNotification.Name("com.xanderlewis.colourSchemeChanged")
    
    init(_ colourScheme: ColourScheme) {
        current = colourScheme
        
        // Restore previous state (if it exists)
        if let darkThemeWasOn = UserDefaults.standard.object(forKey: "darkThemeOn") as? Bool {
            if darkThemeWasOn {
                current = .dark
            } else {
                current = .light
            }
        }
    }
    
    // MARK: - Views
    
    func colourForViewBackground() -> UIColor {
        switch current {
        case .light:
            return UIColor(white: 0.9, alpha: 1.0)
        case .dark:
            return UIColor(white: 0.1, alpha: 1.0)
        }
    }
    
    func styleForBlurEffect() -> UIBlurEffectStyle {
        switch current {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    func colourForUIElementTint() -> UIColor {
        switch current {
        case .light:
            return UIColor(red: 1.0, green: 0.0, blue: 0.36, alpha: 1.0)
        case .dark:
            return UIColor(red: 1.0, green: 0.0, blue: 0.36, alpha: 1.0)
        }
    }
    
    func colourForAboutViewText() -> UIColor {
        switch current {
        case .light:
            return UIColor(white: 0.4, alpha: 1.0)
        case .dark:
            return UIColor(white: 0.5, alpha: 1.0)
        }
        
    }
    
    func colourForHelpViewText() -> UIColor {
        switch current {
        case .light:
            return UIColor(white: 0.3, alpha: 1.0)
        case .dark:
            return UIColor(white: 0.7, alpha: 1.0)
        }
    }
    
    func colourForHelpButton() -> UIColor {
        switch current {
        case .light:
            return UIColor(white: 0.5, alpha: 1.0)
        case .dark:
            return UIColor(white: 0.5, alpha: 1.0)
        }
    }
    
    // MARK: - Table Views
    
    func colourForTableViewBackground() -> UIColor {
        switch current {
        case .light:
            return UIColor(white: 0.85, alpha: 1.0)
        case .dark:
            return colourForViewBackground()
        }
    }
    
    func colourForTableViewSeparator() -> UIColor {
        switch current {
        case .light:
            return UIColor(white: 0.7, alpha: 1.0)
        case .dark:
            return UIColor.black
        }
    }
    
    func colourForTableViewText() -> UIColor {
        switch current {
        case .light:
            return UIColor(white: 0.3, alpha: 1.0)
        case .dark:
            return UIColor(white: 0.7, alpha: 1.0)
        }
    }
    
    func colourForTableViewCellBackground() -> UIColor {
        switch current {
        case .light:
            return UIColor(white: 0.9, alpha: 1.0)
        case .dark:
            return UIColor(white: 0.14, alpha: 1.0)
        }
    }
    
    // MARK: - Physics Simulation
    
    func colourForSimulationBackground() -> UIColor {
        switch current {
        case .light:
            return colourForViewBackground()
        case .dark:
            return colourForViewBackground()
        }
    }
    
    func colourForBackgroundLabel() -> UIColor {
        switch current {
        case .light:
            return UIColor(white: 0.7, alpha: 1)
        case .dark:
            return UIColor(white: 0.2, alpha: 1)
        }
    }
    
    // MARK: - Tab Bar
    
    func styleForTabBar() -> UIBarStyle {
        switch current {
        case .light:
            return .default
        case .dark:
            return .black
        }
    }
    
    // MARK: - Physics Objects
    
    func colourForSpring() -> UIColor {
        switch current {
        case .light:
            return UIColor(white: 0.5, alpha: 1)
        case .dark:
            return UIColor(white: 0.5, alpha: 1)
        }
    }
    
    func colourForSpringShadow() -> UIColor {
        switch current {
        case .light:
            return UIColor(white: 0.85, alpha: 1)
        case .dark:
            return UIColor(white: 0.18, alpha: 1)
        }
    }
}
