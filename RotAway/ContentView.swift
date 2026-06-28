//
//  ContentView.swift
//  RotAway
//
//  Created by Skye Nguyen on 28/6/26.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var trashManager: TrashManager
    
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
        .padding()
        .frame(width: 260, height: 190)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(trashManager: TrashManager())
    }
}
