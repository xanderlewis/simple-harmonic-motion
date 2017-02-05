//
//  Trail.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 18/01/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit
import SpriteKit

class Trail: SKShapeNode {
    
    private var points: [CGPoint] = []
    var length: Int
    
    init(colour c: SKColor, length l: Int) {
        length = l
        
        // Initialise node
        super.init()
        strokeColor = c
        lineWidth = 1
        lineCap = .round
        zPosition = 10
        strokeColor = c
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(sender: Body, velocity: CGFloat, following: Bool) {
        // Move points vertically
        for (i, _) in points.enumerated() {
            points[i].y += velocity
        }
        
        // Add current position
        if points.count >= length {
            points.removeFirst()
        }
        if following {
            points.append(sender.position)
        }
        
        // Render trail
        let newPath = CGMutablePath()
        newPath.addLines(between: points)
        
        path = newPath
    }
    
    func reset() {
        points = []
    }
}
