//
//  CSVGenerator.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 24/01/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import Foundation

/**
 Generates a CSV file in the temporary directory, pulling data from one or more body datasets
*/
class CSVGenerator {
    var bodyDatasets: [BodyDataset] = []
    private var header: String = ""
    
    init(fromBodyDatasets bodyDatasets: [BodyDataset]) {
        self.bodyDatasets = bodyDatasets
        
        header = generateHeaderString()
    }
    
    private func generateHeaderString() -> String {
        var header = ""
        
        header += "Time,"
        
        for i in 0..<bodyDatasets.count {
            header += "Body \(i+1) Mass,"
            header += "Body \(i+1) Damping,"
            header += "Body \(i+1) Displacement,"
            header += "Body \(i+1) Velocity,"
            header += "Body \(i+1) Acceleration,"
            header += "Body \(i+1) Kinetic Energy,"
        }
        
        // Remove trailing comma (prevents an extraneous column)
        if header.characters.last! == "," {
            header.remove(at: header.index(before: header.endIndex))
        }
        
        return header
    }
    
    func generateFile(withFilename filename: String = "simple-harmonic-motion.csv") -> URL {
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
        
        var stringToWrite = ""
        
        stringToWrite += "\(header)\n"
        
        // For each time period
        for i in 0..<bodyDatasets[0].mass.count {
            // Add time
            stringToWrite += "\(i),"
            // Add each dataset to line
            for dataset in bodyDatasets {
                print(dataset.mass)
                print(dataset.mass.count)
                stringToWrite += "\(dataset.mass[i]),"
                stringToWrite += "\(dataset.damping[i]),"
                stringToWrite += "\(dataset.displacement[i]),"
                stringToWrite += "\(dataset.velocity[i]),"
                stringToWrite += "\(dataset.acceleration[i]),"
                stringToWrite += "\(dataset.kineticEnergy[i]),"
            }
            
            // Remove trailing comma (prevents an extraneous column)
            if stringToWrite.characters.last! == "," {
                stringToWrite.remove(at: stringToWrite.index(before: stringToWrite.endIndex))
            }
            
            stringToWrite += "\n"
        }
        
        // Write string to csv file
        if path != nil {
            do {
                try stringToWrite.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                print("failed to write to file")
            }
        } else {
            print("failed to create path in temporary directory.")
        }
        
        return path!
    }
}
