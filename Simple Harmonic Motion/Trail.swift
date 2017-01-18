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
    var verticalVelocity: CGFloat
    var length: Int
    
    init(colour c: SKColor, verticalVelocity vv: CGFloat, length l: Int) {
        verticalVelocity = vv
        length = l
        
        // Initialise node
        super.init()
        strokeColor = c
        lineWidth = 1
        lineCap = .round
        zPosition = 0
        strokeColor = c
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(sender: Body) {
        // Move points vertically
        for (i, _) in points.enumerated() {
            points[i].y += verticalVelocity
        }
        
        // Add current position
        if points.count >= length {
            points.removeFirst()
        }
        
        points.append(sender.position)
        
        // Render trail
        let newPath = CGMutablePath()
        newPath.addLines(between: points)
        
        path = newPath
    }
}
