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
        NotificationCenter.default.addObserver(self, selector: #selector(updateColours), name: NSNotification.Name(AppColourScheme.changed), object: nil)
        
        setUpBlur()
    }
    
    func updateColours() {
        textView.textColor = AppColourScheme.shared.colourForHelpViewText()
        setUpBlur()
        
        // SET FONT SIZE FOR WHOLE ATTRIBUTED STRING
        //textView.attributedText.attribute(NSFontAttributeName , at: 0, effectiveRange: <#T##NSRangePointer?#>)
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
        // Segue back to simulation view
        performSegue(withIdentifier: "UnwindHelp", sender: self)
    }

}
