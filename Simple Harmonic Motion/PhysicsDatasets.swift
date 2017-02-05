//
//  BodyDataset.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 24/01/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import Foundation

// Holds values over time for a body
class BodyDataset: NSObject, NSCoding {
    var mass: [Float] = []
    var damping: [Float] = []
    var displacement: [Float] = []
    var velocity: [Float] = []
    var acceleration: [Float] = []
    var kineticEnergy: [Float] = []
    
    init(mass: [Float], damping: [Float], displacement: [Float], velocity: [Float], acceleration: [Float], kineticEnergy: [Float]) {
        self.mass = mass
        self.damping = damping
        self.displacement = displacement
        self.velocity = velocity
        self.acceleration = acceleration
        self.kineticEnergy = kineticEnergy
    }
    
    override init() { }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let mass = aDecoder.decodeObject(forKey: "mass") as? [Float],
            let damping = aDecoder.decodeObject(forKey: "damping") as? [Float],
            let displacement = aDecoder.decodeObject(forKey: "displacement") as? [Float],
            let velocity = aDecoder.decodeObject(forKey: "velocity") as? [Float],
            let acceleration = aDecoder.decodeObject(forKey: "acceleration") as? [Float],
            let kineticEnergy = aDecoder.decodeObject(forKey: "kineticEnergy") as? [Float]
        else { return nil }
        
        self.init(mass: mass, damping: damping, displacement: displacement, velocity: velocity, acceleration: acceleration, kineticEnergy: kineticEnergy)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(mass, forKey: "mass")
        aCoder.encode(damping, forKey: "damping")
        aCoder.encode(displacement, forKey: "displacement")
        aCoder.encode(velocity, forKey: "velocity")
        aCoder.encode(acceleration, forKey: "acceleration")
        aCoder.encode(kineticEnergy, forKey: "kineticEnergy")
    }
}

// Holds values over time for a spring
struct SpringDataset {
    var stiffness: [Float] = []
    var force: [Float] = []
}

class Recording: NSObject, NSCoding {
    var title = "Untitled"
    var bodyDatasets: [BodyDataset] = []
    
    init(title: String, bodyDatasets: [BodyDataset]) {
        self.title = title
        self.bodyDatasets = bodyDatasets
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: "title") as? String,
            let bodyDatasets = aDecoder.decodeObject(forKey: "bodyDatasets") as? [BodyDataset]
            
            else { print("failed"); return nil }
        
        self.init(title: title, bodyDatasets: bodyDatasets)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(bodyDatasets, forKey: "bodyDatasets")
    }
}
