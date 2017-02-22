//
//  HelpViewController.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 01/02/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    var visualEffectView: UIVisualEffectView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Be notified when app colour scheme changes
        NotificationCenter.default.addObserver(self, selector: #selector(updateColours), name: AppColourScheme.changed, object: nil)
        
        updateColours()
    }
    
    func updateColours() {
        setUpBlur()
        
        var mutableString = NSMutableAttributedString(attributedString: textView.attributedText)
        
        mutableString.addAttribute(NSForegroundColorAttributeName, value: AppColourScheme.shared.colourForHelpViewText(), range: NSRange(location: 0, length: mutableString.length))
        
        textView.attributedText = mutableString
    }
    
    func setUpBlur() {
        // Set up blurred background
        let blurEffect = UIBlurEffect(style: AppColourScheme.shared.styleForBlurEffect())
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(visualEffectView, belowSubview: textView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Segue back to simulation view when tapped
        performSegue(withIdentifier: "UnwindHelp", sender: self)
    }

}
