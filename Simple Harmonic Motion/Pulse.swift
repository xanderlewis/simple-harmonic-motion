//
//  Pulse.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 24/01/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit

class Pulse: CALayer {
    var animationGroup = CAAnimationGroup()
    
    var initialScale: Float = 0
    var interval: TimeInterval = 0
    var pulseDuration: TimeInterval = 1.5
    var radius: CGFloat = 200
    var numberOfPulses: Float = Float.infinity
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init (numberOfPulses: Float = Float.infinity, radius: CGFloat, position: CGPoint) {
        super.init()
        
        backgroundColor = UIColor.black.cgColor
        contentsScale = UIScreen.main.scale
        opacity = 0
        self.radius = radius
        self.numberOfPulses = numberOfPulses
        self.position = position
        
        bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        cornerRadius = radius
        
        DispatchQueue.global().async {
            self.setUpAnimationGroup()
            
            DispatchQueue.main.async {
                self.add(self.animationGroup, forKey: "pulse")
            }
        }
    }
    
    func createScaleAnimation() -> CABasicAnimation {
        let anim = CABasicAnimation(keyPath: "transform.scale.xy")
        anim.fromValue = NSNumber(value: initialScale)
        anim.toValue = NSNumber(value: 1)
        anim.duration = pulseDuration
        
        return anim
    }
    
    func createOpacityAnimation() -> CAKeyframeAnimation {
        let anim = CAKeyframeAnimation(keyPath: "opacity")
        anim.duration = pulseDuration
        anim.values = [0.4, 0.8, 0]
        anim.keyTimes = [0, 0.2, 1]
        
        return anim
    }
    
    func setUpAnimationGroup() {
        animationGroup.duration = pulseDuration + interval
        animationGroup.repeatCount = numberOfPulses
        
        let defaultCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        animationGroup.timingFunction = defaultCurve
        
        animationGroup.animations = [createScaleAnimation(), createOpacityAnimation()]
    }
}
