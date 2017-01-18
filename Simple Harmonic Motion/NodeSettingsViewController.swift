//
//  NodeSettingsViewController.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 18/01/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit

class NodeSettingsViewController: UIViewController {
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var settingsStack: UIStackView!
    @IBOutlet var tapRecogniser: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(white: 0, alpha: 0.2)
        tapRecogniser.cancelsTouchesInView = true
        
        // Animate the view to appear
        animateAppear()
        
        // Configure stack
        settingsStack.alignment = .center
        settingsStack.distribution = .equalSpacing
        
        // Add settings to stack depending on node type
        let titleLabel = UILabel()
        titleLabel.text = "Object settings"
        //titleLabel.font = UIFont.init(name: UIFont.fontNames(forFamilyName: "Damascus")[0], size: 18)
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)
        titleLabel.textColor = UIColor.black
        
        settingsStack.addArrangedSubview(titleLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // If user touched outside of settings view, remove the root view (close node settings)
            if !settingsView.frame.contains(touch.location(in: view)) {
                view.removeFromSuperview()
            }
        }
    }
    
    func animateAppear() {
        settingsView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        settingsView.alpha = 0
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 5, options: [], animations: {
            self.settingsView.alpha = 1
            self.settingsView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }

    @IBAction func tappedView(_ sender: UITapGestureRecognizer) {
        
        if sender.state == .ended {
            let touchPoint = sender.location(ofTouch: 0, in: view)
            
            // If user touched outside of settings view, remove the root view (close node settings)
            if !settingsView.frame.contains(touchPoint) {
                view.removeFromSuperview()
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
