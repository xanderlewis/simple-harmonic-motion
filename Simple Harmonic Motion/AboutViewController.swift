//
//  AboutViewController.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 01/02/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Be notified when app colour scheme changes
        NotificationCenter.default.addObserver(self, selector: #selector(updateColours), name: AppColourSchemeDelegate.changed, object: nil)
        
        updateColours()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func updateColours() {
        view.backgroundColor = AppColourSchemeDelegate.shared.colourForViewBackground()
        textView.textColor = AppColourSchemeDelegate.shared.colourForAboutViewText()
    }

}
