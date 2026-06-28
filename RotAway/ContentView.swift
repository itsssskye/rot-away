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
    
    // Quick preset options the user can click
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
            
            if !hasPermission {
                // ONBOARDING SCREEN (Missing Permissions)
                VStack(spacing: 10) {
                    Text("🔒 Permission Required")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    Text("RotAway needs Full Disk Access to scan and safely delete files from your system Trash.")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        
                    Button("Grant Permission") {
                        openFullDiskAccessSettings()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Check Again") {
                        checkPermissions()
                    }
                    .font(.caption)
                    .buttonStyle(.borderless)
                }
                .padding(.vertical, 5)
            } else {
                // NORMAL MAIN INTERFACE
                VStack(spacing: 12) {
                    Text("Delete items older than:")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Custom Input Row (Type or Pick)
                    HStack(spacing: 8) {
                        // Number input text field
                        TextField("Amount", value: $trashManager.timeValue, formatter: NumberFormatter())
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 70)
                            .multilineTextAlignment(.center)
                        
                        // Unit dropdown picker (Seconds, Minutes, Days)
                        Picker("", selection: $trashManager.timeUnit) {
                            ForEach(unitOptions, id: \.self) { unit in
                                Text(unit).tag(unit)
                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                    }
                    
                    // Safety warning if user sets it below 5 seconds
                    if trashManager.timeUnit == "seconds" && trashManager.timeValue < 5 {
                        Text("⚠️ Minimum limit is 5 seconds")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                    
                    Divider()
                    
                    // Action Buttons
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
        .frame(width: 260, height: !hasPermission ? 220 : 190)
        .onAppear {
            checkPermissions()
        }
    }
    
    // Function to test if the app has Full Disk Access
    func checkPermissions() {
        let fileManager = FileManager.default
        if let trashURL = fileManager.urls(for: .trashDirectory, in: .userDomainMask).first {
            do {
                _ = try fileManager.contentsOfDirectory(at: trashURL, includingPropertiesForKeys: nil, options: [])
                hasPermission = true // Success! We have access.
            } catch {
                hasPermission = false // Failed, system blocked the app :(
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
        // The deep link that tells macOS to open Privacy -> Full Disk Access directly
        let urlString = "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
        if let url = URL(string: urlString) {
            NSWorkspace.shared.open(url)
        }
    }
}
