//
//  BodyDataset.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 24/01/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import Foundation

// Holds values over time for a body
struct BodyDataset {
    var mass: [Float] = []
    var damping: [Float] = []
    var displacement: [Float] = []
    var velocity: [Float] = []
    var acceleration: [Float] = []
    var kineticEnergy: [Float] = []
}

// Holds values over time for a spring
struct SpringDataset {
    var stiffness: [Float] = []
    var force: [Float] = []
}
