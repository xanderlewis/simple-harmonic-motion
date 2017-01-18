//
//  Body.swift
//  SHMPrototype2
//
//  Created by Xander Lewis on 07/10/2016.
//  Copyright © 2016 Xander Lewis. All rights reserved.
//

import Foundation
import SpriteKit

class Body: SKSpriteNode {
    
    let mass: CGFloat
    let restPosition: CGPoint
    var displacement: CGFloat = 0 {
        didSet {
            // Keep node x position in sync with displacement
            self.position = CGPoint(x: self.restPosition.x + self.displacement , y: self.position.y)
        }
    }
    var velocity: CGFloat = 0
    var acceleration: CGFloat = 0
    
    let damping: CGFloat
    
    var linkedSprings: [Spring] = []
    
    var isFrozen = false
    
    var trail: Trail?
    
    /**
     Creates a body.
     
     - parameter position: The position of the body in the coordinates of the parent node.
     - parameter colour: The colour of the body.
     - parameter mass: The mass of the body.
     - parameter damping: The damping coefficient to be used to simulate friction acting against the body.
     */
    init(position p: CGPoint, colour c: SKColor, mass m: CGFloat, damping d: CGFloat) {
        
        // Initialise model properties
        self.mass = m
        self.restPosition = p
        self.damping = d
        
        
        // Initialise node properties
        super.init(texture: nil, color: c, size: CGSize(width: m, height: m))
        position = p
        zPosition = 100
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        name = "body"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Links a spring to the body.
     
     - parameter spring: The spring to be linked to the body.
     */
    func link(spring: Spring) {
        linkedSprings.append(spring)
    }
    
    func unlinkSprings() {
        linkedSprings = []
    }
    
    /**
     Applies a force to the body.
     
    - parameter force: The force to be applied to the body.
    */
    func applyForce(force: CGFloat) {
        self.acceleration = (force / self.mass) - (self.damping * self.velocity)
    }
    
    /**
     Advances the body's position by one 'tick'.
     */
    func updatePosition() {
        self.velocity += self.acceleration
        self.displacement += self.velocity
        
        if trail != nil {
            trail!.update(sender: self)
        }
    }
}
