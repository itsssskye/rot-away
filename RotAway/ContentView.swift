//
//  ContentView.swift
//  RotAway
//
//  Created by Skye Nguyen on 28/6/26.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var trashManager: TrashManager
    @State private var hasPermission: Bool = false
    
    // Tracks if this is the user's very first time opening the app
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    
    let unitOptions = ["seconds", "minutes", "days"]

    var body: some View {
        VStack(spacing: 12) {
            // App Branding
            HStack {
                Image(systemName: "trash.slash")
                    .font(.title2)
                    .foregroundColor(.secondary)
                Text("RotAway")
                    .font(.headline)
            }
            
            Divider()
            
            // Show onboarding ONLY if it's the first launch AND we don't have permission yet
            if isFirstLaunch && !hasPermission {
                VStack(spacing: 10) {
                    Text("🔒 Welcome to RotAway")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    Text("RotAway needs Full Disk Access to scan and safely delete files from your system Trash folder.")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        
                    Button("Grant Permission") {
                        openFullDiskAccessSettings()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("I've Granted It - Start App") {
                        checkPermissions()
                        // If they successfully gave access, turn off the first-launch screen forever
                        if hasPermission {
                            isFirstLaunch = false
                        }
                    }
                    .font(.caption)
                    .buttonStyle(.bordered)
                }
                .padding(.vertical, 5)
            } else {
                // NORMAL UTILITY INTERFACE (Hidden after setup)
                VStack(spacing: 12) {
                    Text("Delete items older than:")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 8) {
                        TextField("Amount", value: $trashManager.timeValue, formatter: NumberFormatter())
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 70)
                            .multilineTextAlignment(.center)
                        
                        Picker("", selection: $trashManager.timeUnit) {
                            ForEach(unitOptions, id: \.self) { unit in
                                Text(unit).tag(unit)
                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                    }
                    
                    if trashManager.timeUnit == "seconds" && trashManager.timeValue < 5 {
                        Text("⚠️ Minimum limit is 5 seconds")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                    
                    Divider()
                    
                    HStack(spacing: 10) {
                        Button("Clean Now") {
                            trashManager.checkAndEmptyTrash()
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("Quit") {
                            NSApplication.shared.terminate(nil)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
        }
        .padding()
        .frame(width: 260, height: (isFirstLaunch && !hasPermission) ? 220 : 190)
        .onAppear {
            checkPermissions()
            // If they already have permission from a previous session, bypass onboarding completely
            if hasPermission {
                isFirstLaunch = false
            }
        }
    }
    
    func checkPermissions() {
        let fileManager = FileManager.default
        if let trashURL = fileManager.urls(for: .trashDirectory, in: .userDomainMask).first {
            do {
                _ = try fileManager.contentsOfDirectory(at: trashURL, includingPropertiesForKeys: nil, options: [])
                hasPermission = true
            } catch {
                hasPermission = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(trashManager: TrashManager())
    }
}

extension ContentView {
    func openFullDiskAccessSettings() {
        let urlString = "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
        if let url = URL(string: urlString) {
            NSWorkspace.shared.open(url)
        }
    }
}
