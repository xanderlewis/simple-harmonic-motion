//
//  NodeSettingsViewController.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 18/01/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit

class NodeSettingsViewController: UIViewController {
    @IBOutlet var tapRecogniser: UITapGestureRecognizer!
    
    let settingsViewHeight: CGFloat = 180
    let settingsViewWidth: CGFloat = 240
    let settingsViewSpacer: CGFloat = 20
    
    var settingsView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        tapRecogniser.cancelsTouchesInView = true
        
        // Animate the view to appear
        animateAppear()
    }
    
    func prepareSettings(forObjectWithName objectName: String, atPosition position: CGPoint) {
        // Prepare settings view
        settingsView = UIView()
        settingsView.backgroundColor = UIColor.white
        view.addSubview(settingsView)
        
        // Add layout constraints to settings view
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: settingsView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: settingsViewWidth)
        let heightConstraint = NSLayoutConstraint(item: settingsView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: settingsViewHeight)
        let xConstraint = NSLayoutConstraint(item: settingsView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        
        var yConstraintConstant = position.y
        
        // If bottom of settings view intersects with bottom of root view
        if yConstraintConstant + settingsViewHeight/2 > view.frame.height {
            // Shift negative (up)
            yConstraintConstant -= (position.y + settingsViewHeight/2) - view.frame.height + settingsViewSpacer
            
        // If top of settings view intersects with top of root view
        } else if yConstraintConstant - settingsViewHeight/2 < 0 {
            // Shift positive (down)
            yConstraintConstant -= (position.y - settingsViewHeight/2) - settingsViewSpacer
        }
        
        
        let yConstraint = NSLayoutConstraint(item: settingsView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: yConstraintConstant)
        
        NSLayoutConstraint.activate([widthConstraint, heightConstraint, xConstraint, yConstraint])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            // If user touched outside of settings view, animate remove the root view (close node settings)
//            if !settingsView.frame.contains(touch.location(in: view)) {
//                animateDisappear()
//            }
//        }
//    }
    
    func animateAppear() {
        settingsView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        settingsView.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 20, options: [], animations: {
            self.view.backgroundColor = UIColor(white: 0, alpha: 0.3)
            self.settingsView.alpha = 1
            self.settingsView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
    func animateDisappear() {
        UIView.animate(withDuration: 0.08, animations: {
            self.settingsView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (finished) in
            UIView.animate(withDuration: 0.15, animations: {
                self.settingsView.alpha = 0
                self.settingsView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                self.view.backgroundColor = UIColor(white: 0, alpha: 0.0)
            }, completion: { (finished) in
                if finished {
                    self.view.removeFromSuperview()
                }
            })
            
        }
    }

    @IBAction func tappedView(_ sender: UITapGestureRecognizer) {
        
        if sender.state == .ended {
            let touchPoint = sender.location(ofTouch: 0, in: view)
            
            // If user touched outside of settings view, remove the root view (close node settings)
            if !settingsView.frame.contains(touchPoint) {
                animateDisappear()
            }
        }
    }
}
