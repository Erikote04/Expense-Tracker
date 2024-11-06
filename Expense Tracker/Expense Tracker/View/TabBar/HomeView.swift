//
//  ContentView.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 30/10/24.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("isAppLockInBackground") private var isAppLockInBackground: Bool = false
    
    @State private var activeTab: Tab = .recents
    
    var body: some View {
        LockView(lockType: .both, lockPin: "1234", isEnabled: isAppLockEnabled, isAppLockInBackground: isAppLockInBackground) {
            TabView(selection: $activeTab) {
                RecentsView()
                    .tag(Tab.recents)
                    .tabItem {
                        Tab.recents.tabLabel
                    }
                
                SearchView()
                    .tag(Tab.search)
                    .tabItem {
                        Tab.search.tabLabel
                    }
                
                GraphsView()
                    .tag(Tab.charts)
                    .tabItem {
                        Tab.charts.tabLabel
                    }
                
                SettingsView()
                    .tag(Tab.settings)
                    .tabItem {
                        Tab.settings.tabLabel
                    }
            }
            .tint(appTint)
            .sheet(isPresented: $isFirstTime) {
                FirstTimeExperienceView()
                    .interactiveDismissDisabled()
            }
        }
    }
}

#Preview {
    HomeView()
}
