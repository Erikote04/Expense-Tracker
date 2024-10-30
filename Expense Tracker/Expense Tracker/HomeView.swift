//
//  ContentView.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 30/10/24.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @State private var activeTab: Tab = .recents
    
    var body: some View {
        TabView(selection: $activeTab) {
            Text("Recents")
                .tag(Tab.recents)
                .tabItem {
                    Tab.recents.tabLabel
                }
            
            Text("Search")
                .tag(Tab.search)
                .tabItem {
                    Tab.search.tabLabel
                }
            
            Text("Charts")
                .tag(Tab.charts)
                .tabItem {
                    Tab.charts.tabLabel
                }
            
            Text("Settings")
                .tag(Tab.settings)
                .tabItem {
                    Tab.settings.tabLabel
                }
        }
        .sheet(isPresented: $isFirstTime) {
            FirstTimeExperienceView()
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    HomeView()
}
