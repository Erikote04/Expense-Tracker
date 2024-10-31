//
//  SettingsView.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 30/10/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("isAppLockInBackground") private var isAppLockInBackground: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("User name") {
                    TextField("Name", text: $userName)
                }
                
                Section("App lock") {
                    Toggle("Enable app lock", isOn: $isAppLockEnabled)
                    
                    if isAppLockEnabled {
                        Toggle("Enable app lock in background", isOn: $isAppLockInBackground)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    HomeView()
}
