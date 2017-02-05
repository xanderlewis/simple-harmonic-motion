//
//  RecordingsArchiveManager.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 04/02/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import Foundation

class RecordingsArchiveManager {
    var fileName = "shm-recordings-archive"
    var fileURL: URL!
    
    init() {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = documentDirectory.appendingPathComponent(fileName)
    }
    
    func add(newRecording: Recording) {
        // Load existing archive
        var archive = NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path) as? [Recording]
        
        if archive == nil {
            archive = []
        }
        
        // Add new recording to archive
        archive!.append(newRecording)
        
        // Write archive
        NSKeyedArchiver.archiveRootObject(archive!, toFile: fileURL.path)
    }
    
    func replace(withNewRecordings newRecordings: [Recording]) {
        // Write
        NSKeyedArchiver.archiveRootObject(newRecordings, toFile: fileURL.path)
    }
    
    func getRecordings() -> [Recording] {
        if let archive = NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path) as? [Recording] {
            return archive
        } else {
            print("Could not load recordings archive from file.")
            return []
        }
    }
}
