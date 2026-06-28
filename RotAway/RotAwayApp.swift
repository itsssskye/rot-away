//
//  RotAwayApp.swift
//  RotAway
//
//  Created by Skye Nguyen on 28/6/26.
//

import SwiftUI

@main
struct RotAwayApp: App {
    // Create a single instance of the backend manager to run globally
    @StateObject private var trashManager = TrashManager()

    var body: some Scene {
        // This converts the normal app into a sleek menu bar dropdown utility!
        MenuBarExtra("RotAway", systemImage: "trash.slash") {
            ContentView(trashManager: trashManager)
        }
        .menuBarExtraStyle(.window)
    }
}

