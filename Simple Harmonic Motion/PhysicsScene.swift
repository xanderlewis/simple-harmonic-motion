//
//  PhysicsScene.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 16/01/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import SpriteKit
import GameplayKit

// Default physics constants for simulation (used when creating new objects)
// (Limited to this physics scene)
struct DefaultConstants {
    static let bodyColour = SKColor.white
    static let springColour = UIColor(white: 0.8, alpha: 1)
    static let mass: CGFloat = 60
    static let damping: CGFloat = 0.008
    static let springWidth: CGFloat = 20
    static let springStiffness: CGFloat = 5
    static let springSections: Int = 18
    static let verticalSpacing: CGFloat = 20
    static let trailColour = UIColor.yellow
    static let trailVelocity: CGFloat = 2
    static let trailLength: Int = 420
}

class PhysicsScene: SKScene {
    
    // Gesture recognisers
    //var tapRec: UITapGestureRecognizer!
    var longPressRec: UILongPressGestureRecognizer!
    
    // Keep track of which bodies are being dragged, and where they were first touched (x position)
    var selectedBodies: [UITouch: Body] = [:]
    var firstTouchPoint: [Body: CGFloat] = [:]
    
    // Keep reference to presenting view controller
    var viewController: PhysicsViewController!
    
    // Last touch down x value and time
    var lastTouchDownX: CGFloat!
    var lastTouchDownTime: TimeInterval!
    
    override func didMove(to view: SKView) {
        // Set up gesture recognisers
        setUpGestureRecognizers()
        
        // Set background colour
        backgroundColor = UIColor(white: 0.3, alpha: 1)
    }
    
    func tickPhysics() {
        
        // Apply springs forces to (non-frozen) linked bodies and update their positions
        enumerateChildNodes(withName: "body") { (node, stop) in
            let body = node as! Body
            
            if !body.isFrozen {
                if !body.linkedSprings.isEmpty {
                    for spring in body.linkedSprings {
                        body.applyForce(force: spring.force)
                    }
                }
                body.updatePosition()
            }
            
            body.updateTrail()
        }
        
        // Deform springs based on displacement of linked bodies
        enumerateChildNodes(withName: "spring") { (node, stop) in
            let spring = node as! Spring
            if !spring.linkedBodies.isEmpty {
                for body in spring.linkedBodies {
                    spring.deform(change: body.displacement)
                }
                spring.updatePath()
            }
        }

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Move physics forward one 'tick'
        tickPhysics()
    }
    
    func createTriplet(atPosition bodyPosition: CGPoint) {
        // Create a spring-body-spring 'triplet'
        
        // Create body instance
        let body = Body(position: CGPoint(x: frame.width / 2, y: bodyPosition.y),
                        colour: DefaultConstants.bodyColour,
                        mass: DefaultConstants.mass,
                        damping: DefaultConstants.damping)
        
        // Create left spring instance
        let leftSpring = Spring(position: CGPoint(x: 0,
                                                  y: body.position.y - DefaultConstants.springWidth / 2),
                                colour: DefaultConstants.springColour,
                                orientation: .facingRight,
                                length: body.position.x - body.mass / 2,
                                width: DefaultConstants.springWidth,
                                stiffness: DefaultConstants.springStiffness,
                                sections: DefaultConstants.springSections)
        
        // Create right spring instance
        let rightSpring = Spring(position: CGPoint(x: frame.width,
                                                   y: body.position.y - DefaultConstants.springWidth / 2),
                                 colour: DefaultConstants.springColour,
                                 orientation: .facingLeft,
                                 length: frame.width - (body.position.x + body.mass / 2),
                                 width: DefaultConstants.springWidth,
                                 stiffness: DefaultConstants.springStiffness,
                                 sections: DefaultConstants.springSections)
        
        // Create trail for body
        let trail = Trail(colour: DefaultConstants.trailColour, verticalVelocity: DefaultConstants.trailVelocity, length: DefaultConstants.trailLength)
        
        // Add trail to body
        body.trail = trail
        
        // Link bodies and springs
        body.link(spring: leftSpring)
        leftSpring.link(body: body)
        body.link(spring: rightSpring)
        rightSpring.link(body: body)
        
        // Add as children to scene (root node)
        self.addChild(body)
        self.addChild(leftSpring)
        self.addChild(rightSpring)
        self.addChild(trail)
        
        // Animations
        let shrink = SKAction.scale(to: 0.5, duration: 0)
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let expand = SKAction.scale(to: 1.0, duration: 0.1)
        
        body.alpha = 0
        leftSpring.alpha = 0
        rightSpring.alpha = 0
        trail.alpha = 0
        
        body.run(shrink) {
            body.run(fadeIn)
            body.run(expand)
        }
        leftSpring.run(fadeIn)
        rightSpring.run(fadeIn) {
            trail.run(fadeIn)
        }
        
        
    }
    
    // MARK: - Tap/drag handling
    // TAP:  DOESN'T MOVE, DOWN FOR < 100ms
    // DRAG: MOVES, DOWN FOR > 200ms
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            for node in nodes(at: touch.location(in: self)) {
                if node.name == "body" {
                    let body = node as! Body
                    
                    // Freeze body
                    body.isFrozen = true
                    
                    // Associate body with touch
                    selectedBodies[touch] = body
                    firstTouchPoint[body] = touch.location(in: self).x
                }
            }
        }
        
        // Store touch down and time
        print("touchdown")
        lastTouchDownX = touches.first!.location(in: self).x
        lastTouchDownTime = event?.timestamp
        print("storing location", lastTouchDownX)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let body = selectedBodies[touch] {
                body.displacement = touch.location(in: self).x - firstTouchPoint[body]!
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchup")
        print("last location", lastTouchDownX)
        print("current location", touches.first!.location(in: self).x)
        
        // If time delta less than 200ms, it hasn't moved, and there's only one finger on the screen... it's a tap!
        let delta = (event?.timestamp)! - lastTouchDownTime
        if delta < 0.2 && touches.first!.location(in: self).x == lastTouchDownX && touches.count == 1 {
            // User tapped on scene
            tappedScene(withTouch: touches.first!)
        } else {
            // User dragged on scene
        }
        for touch in touches {
            if let body = selectedBodies[touch] {
                body.isFrozen = false
                selectedBodies.removeValue(forKey: touch)
            }
        }
    }
    
    func tappedScene(withTouch touch: UITouch) {
        // Called when user taps on scene
            
        // Get location of tap
        let tapLocation = touch.location(in: view)
        let tapPosition = convertPoint(fromView: tapLocation)
            
        for node in nodes(at: tapPosition) {
            if node is Body {
                    
                // Tapped on a body -> get dictionary of settings
                // NEED TO WORK OUT A WAY OF GETTING DATA BACK FROM SETTINGS VIEW (POSSIBLE RETHINK THIS WHOLE STRUCTURE)
                let newSettings = viewController.getSettings(forObjectWithName: "body", atPoint: convertPoint(toView: node.position))
                    
                return
                    
            } else if node is Spring {
                // Tapped on a spring -> get dictionary of settings
                let newSettings = viewController.getSettings(forObjectWithName: "spring", atPoint: convertPoint(toView: node.position))
                    
                return
            }
                
        }
            
    // Tapped in empty space (create a triplet)
            
        var bodyFits = true
        enumerateChildNodes(withName: "body", using: { (node, stop) in
            let body = node as! Body
                
            let trialFrame = CGRect(x: 0, y: tapPosition.y - body.frame.width/2, width: (self.view?.frame.width)!, height: body.frame.height)
                
                
                
            // Check if body intersects with existing body
            if trialFrame.intersects(body.frame) {
                print("new trial frame intersects existing body")
                // Stop checking
                bodyFits = false
                stop.initialize(to: true)
            }
        })
            
        if bodyFits {
            // Create 'triplet'
            createTriplet(atPosition: convertPoint(fromView: tapLocation))
        }
    }
    
    // MARK: - Gesture Responses
    
    func longPressedScene() {
        // Called when user taps and holds on scene for a while
        
        print("Long pressed physics scene!")
    }
    
    func setUpGestureRecognizers() {
        //tapRec = UITapGestureRecognizer(target: self, action: #selector(tappedScene))
        longPressRec = UILongPressGestureRecognizer(target: self, action: #selector(longPressedScene))
        
        //tapRec.cancelsTouchesInView = false
        longPressRec.minimumPressDuration = 0.8
        
        //view?.addGestureRecognizer(tapRec)
        view?.addGestureRecognizer(longPressRec)
    }
}
