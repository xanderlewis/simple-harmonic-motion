//
//  PhysicsScene.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 16/01/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import SpriteKit
import GameplayKit

// Default physics constants for simulation
public struct DefaultSimulationConstants {
    static let mass: CGFloat = 50
    static let damping: CGFloat = 0.02
    static let springWidth: CGFloat = 14
    static let springStiffness: CGFloat = 5
    static let springSections: Int = 22
    static let springToBodyContactZone: CGFloat = 2
    static let verticalSpacing: CGFloat = 20
    static var trailLength: Int = 400
    
    static var trailsEnabled = true
    static var trailVelocity: CGFloat = 2.5 {
        didSet {
            // Change trail length depending on velocity to make sure it stays on the screen
            trailLength = Int(trailVelocity * 240)
        }
    }
}

typealias bodyID = Int

class PhysicsScene: SKScene {
    
    // Gesture recognisers
    //var tapRec: UITapGestureRecognizer!
    var longPressRec: UILongPressGestureRecognizer!
    
    // Keep track of which bodies are being dragged, and where they were first touched (x position)
    var selectedBodies: [UITouch: Body] = [:]
    var firstTouchPoint: [Body: CGFloat] = [:]
    var originalDisplacement: [Body: CGFloat] = [:]
    
    // Keep reference to presenting view controller
    var viewController: PhysicsViewController!
    
    // Last touch down x value and time
    var lastTouchDownX: CGFloat!
    var lastTouchDownTime: TimeInterval!
    
    // Data recording
    var recording = false
    var bodyDatasets: [bodyID: BodyDataset] = [:]
    
    // Background grid
    var background: SKSpriteNode!
    
    var physicsIsFrozen = false
    
    // MARK: - Initialising stuff
    
    override func didMove(to view: SKView) {
        
        // Set up gesture recognisers
        setUpGestureRecognizers()
        
        // Set background colour
        backgroundColor = AppColourScheme.shared.colourForSimulationBackground()
        
        // Set up background grid
        background = SKSpriteNode(imageNamed: "darkGrid")
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint.zero
        background.zPosition = 0
        addChild(background)
        
        // Set up background label
        let backgroundLabel = SKLabelNode(text: "Tap anywhere to add a mass")
        backgroundLabel.fontName = "Damascus Light"
        backgroundLabel.fontSize = 20
        backgroundLabel.fontColor = backgroundColor.lighter(10)!
        backgroundLabel.horizontalAlignmentMode = .center
        backgroundLabel.verticalAlignmentMode = .center
        backgroundLabel.position = CGPoint(x: frame.width/2, y: frame.height/2)
        backgroundLabel.name = "backgroundlabel"
        addChild(backgroundLabel)
        
        updateColours()
    }
    
    // MARK: - Colour scheme
    
    func updateColours() {
        backgroundColor = AppColourScheme.shared.colourForSimulationBackground()
        
        switch AppColourScheme.shared.current {
        case .light:
            background.texture = SKTexture(imageNamed: "lightGrid")
        case .dark:
            background.texture = SKTexture(imageNamed: "darkGrid")
        }
        
        enumerateChildNodes(withName: "spring") { (node, stop) in
            let spring = node as! Spring
            spring.strokeColor = AppColourScheme.shared.colourForSpring()
            spring.shadow?.strokeColor = AppColourScheme.shared.colourForSpringShadow()
        }
        
        enumerateChildNodes(withName: "backgroundlabel") { (node, stop) in
            let label = node as! SKLabelNode
            
            label.fontColor = AppColourScheme.shared.colourForBackgroundLabel()
        }
    }
    
    // MARK: - Start/stop recording
    
    func initiateRecording() {
        // Create a dataset for each body and associate the pair
        enumerateChildNodes(withName: "body") { (node, stop) in
            let body = node as! Body
            
            if self.bodyDatasets[body.id] == nil {
                self.bodyDatasets[body.id] = BodyDataset()
            }
        }
        
        recording = true
    }
    
    func finishRecording(sender: RecordButton) {
        recording = false
        
        // Generate title
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd.MM.yy"
        var masses: String
        if bodyDatasets.count == 1 {
            masses = "1 mass"
        } else {
            masses = "\(bodyDatasets.count) masses"
        }
        let title = "\(masses) @ \(formatter.string(from: date))"
        
        // Save recording
        let newRecording = Recording(title: title, bodyDatasets: Array(bodyDatasets.values))
        let archiver = RecordingsArchiveManager()
        archiver.add(newRecording: newRecording)
        
        // Empty body datasets
        bodyDatasets = [:]
        
        // Tell tab bar to increment number of new recordings
        let tabBarController = viewController.tabBarController as? TabBarController
        tabBarController?.incrementNewRecordings()
    }
    
    // MARK: - Update Loop
    
    override func update(_ currentTime: TimeInterval) {
        // Move physics forward one 'tick'
        tickPhysics()
        
        // Enable record button if there are bodies
        if Body.totalBodies > 0 && viewController?.recordButton?.recordingState == .disabled {
            viewController?.recordButton?.recordingState = .stopped
        } else if Body.totalBodies <= 0 {
            viewController?.recordButton?.recordingState = .disabled
        }
        
        // Record data for each body
        if recording {
            enumerateChildNodes(withName: "body", using: { (node, stop) in
                let body = node as! Body
                
                self.bodyDatasets[body.id]!.mass.append(Float(body.mass))
                self.bodyDatasets[body.id]!.damping.append(Float(body.damping))
                self.bodyDatasets[body.id]!.displacement.append(Float(body.displacement))
                self.bodyDatasets[body.id]!.velocity.append(Float(body.velocity))
                self.bodyDatasets[body.id]!.acceleration.append(Float(body.acceleration))
                self.bodyDatasets[body.id]!.kineticEnergy.append(Float(0.5 * body.mass * pow(body.velocity, 2))) // 1/2(mv^2)
            })
        }
        
        // Show label if no bodies
        if Body.totalBodies <= 0 {
            enumerateChildNodes(withName: "backgroundlabel") { (node, stop) in
                node.isHidden = false
                node.run(SKAction.fadeAlpha(to: 1, duration: 0.1))
                node.run(SKAction.scale(to: 1, duration: 0.1))
            }
        }
    }

    func tickPhysics() {
        
        // Apply springs forces to (non-frozen) linked bodies and update their positions
        if !physicsIsFrozen {
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
                
                body.updateTrail(velocity: DefaultSimulationConstants.trailVelocity, following: DefaultSimulationConstants.trailsEnabled)
            }
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
    
    // MARK: - Creating and removing bodies and springs
    
    func createTriplet(atPosition bodyPosition: CGPoint) {
        // Create a spring-body-spring 'triplet'
        
        // Hide background label
        enumerateChildNodes(withName: "backgroundlabel") { (node, stop) in
            node.run(SKAction.fadeAlpha(to: 0, duration: 0.1))
            node.run(SKAction.scale(to: 0.1, duration: 0.1)) {
                node.isHidden = true
            }
            
        }
        
        // Create body instance
        let body = Body(position: CGPoint(x: frame.width / 2, y: bodyPosition.y),
                        colour: BodyColourPalette.random(),
                        mass: DefaultSimulationConstants.mass,
                        damping: DefaultSimulationConstants.damping)
        
        // Create left spring instance
        let leftSpring = Spring(position: CGPoint(x: 0,
                                                  y: body.position.y - DefaultSimulationConstants.springWidth / 2),
                                colour: AppColourScheme.shared.colourForSpring(),
                                orientation: .facingRight,
                                length: body.position.x,
                                width: DefaultSimulationConstants.springWidth,
                                stiffness: DefaultSimulationConstants.springStiffness,
                                sections: DefaultSimulationConstants.springSections)
        
        // Create right spring instance
        let rightSpring = Spring(position: CGPoint(x: frame.width,
                                                   y: body.position.y - DefaultSimulationConstants.springWidth / 2),
                                 colour: AppColourScheme.shared.colourForSpring(),
                                 orientation: .facingLeft,
                                 length: body.position.x,
                                 width: DefaultSimulationConstants.springWidth,
                                 stiffness: DefaultSimulationConstants.springStiffness,
                                 sections: DefaultSimulationConstants.springSections)
        
        // Create trail for body
        let trail = Trail(colour: body.color, length: DefaultSimulationConstants.trailLength)
        
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
    
    func removeTriplet(thatContainsBody body: Body) {
        // Define animations
        let shrink = SKAction.scale(to: 0.1, duration: 0.3)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        
        for spring in body.linkedSprings {
            // Animate spring disappearing
            spring.run(shrink)
            spring.run(fadeOut) {
                // Remove spring
                spring.removeFromParent()
                NSObject.cancelPreviousPerformRequests(withTarget: spring)
            }
        }
        
        // Animate trail disappearing
        body.trail?.run(fadeOut) {
            // Remove trail
            body.trail?.removeFromParent()
            NSObject.cancelPreviousPerformRequests(withTarget: body.trail!)
        }
        
        // Animate body disappearing
        body.run(shrink)
        body.run(fadeOut) {
            // Remove body
            body.removeFromParent()
            NSObject.cancelPreviousPerformRequests(withTarget: body)
            Body.totalBodies -= 1
        }
    }
    
    func disableTrails() {
        enumerateChildNodes(withName: "body") { (node, stop) in
            let body = node as! Body
            body.trail?.isHidden = true
        }
    }
    
    // MARK: - Refresh when device orientation changes
    
    func refreshTripletPositions(toFit newSize: CGSize) {
        // Refresh spring lengths
        enumerateChildNodes(withName: "spring") { (node, stop) in
            let spring = node as! Spring
            
            if spring.orientation == .facingRight {
                spring.initialLength = newSize.width / 2
                spring.currentLength = newSize.width / 2
            } else {
                spring.position = CGPoint(x: newSize.width, y: spring.position.y)
                spring.initialLength = newSize.width / 2
                spring.currentLength = newSize.width / 2
            }
        }
        
        // Refresh body positions
        enumerateChildNodes(withName: "body") { (node, stop) in
            let body = node as! Body
            
            body.position = CGPoint(x: newSize.width / 2, y: body.position.y)
            body.displacement = 0
            body.restPosition = CGPoint(x: newSize.width / 2, y: body.restPosition.y)
        }
    }
    
    func refreshLabelPositions(toFit newSize: CGSize) {
        enumerateChildNodes(withName: "backgroundlabel") { (node, stop) in
            let label = node as! SKLabelNode
            
            label.position = CGPoint(x: newSize.width / 2, y: newSize.height / 2)
        }
    }
    
    func refreshTrailPositions(toFit newSize: CGSize) {
        enumerateChildNodes(withName: "body") { (node, stop) in
            let body = node as! Body
            let trail = body.trail!
            
            trail.reset()
        }
    }
    
    // MARK: - Tap/drag handling
    // (TAP:  DOESN'T MOVE, DOWN FOR < 200ms)
    // (DRAG: MOVES, DOWN FOR >= 200ms)
    
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
                    
                    // Store original body displacement
                    originalDisplacement[body] = body.displacement
                }
            }
        }
        
        // Store touch down and time
        lastTouchDownX = touches.first!.location(in: self).x
        lastTouchDownTime = event?.timestamp
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let body = selectedBodies[touch] {
                body.displacement = originalDisplacement[body]! + touch.location(in: self).x - firstTouchPoint[body]!
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
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
                body.velocity = 0
                body.acceleration = 0
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
            if node is Body || node is Spring {
                // Tapped on a body or spring -> show settings (pass reference to node)
                self.viewController.showSettings(forObject: node)
                return
            }
        }
        
        // Tapped in empty space (create a triplet)
        
        if !recording {
            var bodyFits = true
            enumerateChildNodes(withName: "body", using: { (node, stop) in
                let body = node as! Body
                
                let trialFrame = CGRect(x: 0, y: tapPosition.y - body.frame.width/2, width: (self.view?.frame.width)!, height: body.frame.height)
                
                // Check if body intersects with existing body
                if trialFrame.intersects(body.frame) {
                    // Stop checking
                    bodyFits = false
                    stop.initialize(to: true)
                }
            })
            
            if bodyFits {
                // Create 'triplet'
                createTriplet(atPosition: convertPoint(fromView: tapLocation))
            }

        } else {
            // User tried to create a body whilst recording
            let vc = UIAlertController(title: "Hang on!", message: "We're recording some data at the moment. Stop recording if you want to add a new mass.", preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "Okay! 😌", style: .default, handler: nil))
            
            view?.window?.rootViewController?.present(vc, animated: true, completion: nil)
        }
    }
    
    // MARK: - Gesture Responses
    
    func longPressedScene(sender: UILongPressGestureRecognizer) {
        // Called when user taps and holds on scene for a while
        
        // If long pressed on body and not recording, give user option to delete
        if !recording {
            for node in nodes(at: convertPoint(fromView: sender.location(ofTouch: 0, in: view))) {
                if let body = node as? Body {
                    
                    let vc = UIAlertController(title: "Delete Mass", message: "Would you like to delete this mass from the world?", preferredStyle: .actionSheet)
                    
                    vc.addAction(UIAlertAction(title: "Yes, delete it", style: .destructive, handler: { (action) in
                        // Delete body node
                        self.removeTriplet(thatContainsBody: body)
                    }))
                    
                    vc.addAction(UIAlertAction(title: "No, wait!", style: .cancel, handler: { (action) in
                        body.isFrozen = false
                    }))
                    
                    vc.popoverPresentationController?.sourceView = view
                    vc.popoverPresentationController?.sourceRect = CGRect(x: convertPoint(toView: body.position).x, y: convertPoint(toView: body.position).y, width: 1, height: 1)
                    
                    view?.window?.rootViewController?.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    func setUpGestureRecognizers() {
        //tapRec = UITapGestureRecognizer(target: self, action: #selector(tappedScene))
        longPressRec = UILongPressGestureRecognizer(target: self, action: #selector(longPressedScene))
        
        //tapRec.cancelsTouchesInView = false
        longPressRec.minimumPressDuration = 0.6
        
        //view?.addGestureRecognizer(tapRec)
        view?.addGestureRecognizer(longPressRec)
    }
}
