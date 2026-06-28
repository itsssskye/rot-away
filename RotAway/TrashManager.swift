//
//  TrashManager.swift
//  RotAway
//
//  Created by Skye Nguyen on 28/6/26.
//

import Foundation
import AppKit
import Combine

class TrashManager: ObservableObject {
    // Custom user input values
    @Published var timeValue: Double = 5.0
    @Published var timeUnit: String = "seconds" // "seconds", "minutes", "days"
    
    private var timer: Timer?

    init() {
        startTimer()
    }

    // Convert the user's custom input into total seconds
    var totalSecondsCutoff: Double {
        let minimumSeconds = 5.0 // The safety floor
        let calculated: Double
        
        switch timeUnit {
        case "minutes":
            calculated = timeValue * 60
        case "days":
            calculated = timeValue * 86400
        default: // "seconds"
            calculated = timeValue
        }
        
        return max(calculated, minimumSeconds)
    }

    func startTimer() {
        timer?.invalidate()
        // Check the trash frequently (every 5 seconds) to catch fast intervals
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            self?.checkAndEmptyTrash()
        }
    }

    func checkAndEmptyTrash() {
        let fileManager = FileManager.default
        
        guard let trashURL = fileManager.urls(for: .trashDirectory, in: .userDomainMask).first else {
            print("Could not find the Trash folder.")
            return
        }
        
        do {
            let resourceKeys: [URLResourceKey] = [.addedToDirectoryDateKey]
            let fileURLs = try fileManager.contentsOfDirectory(at: trashURL, includingPropertiesForKeys: resourceKeys, options: [])
            
            // Subtract the custom cutoff seconds from the current time
            let cutoffDate = Date().addingTimeInterval(-totalSecondsCutoff)

            for fileURL in fileURLs {
                let resourceValues = try fileURL.resourceValues(forKeys: Set(resourceKeys))
                
                if let addedDate = resourceValues.addedToDirectoryDate {
                    if addedDate < cutoffDate {
                        try fileManager.removeItem(at: fileURL)
                        print("RotAway deleted: \(fileURL.lastPathComponent)")
                    }
                }
            }
        } catch {
            print("Error scanning trash: \(error.localizedDescription)")
        }
    }
}
