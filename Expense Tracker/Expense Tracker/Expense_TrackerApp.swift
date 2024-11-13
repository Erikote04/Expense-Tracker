//
//  Expense_TrackerApp.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 30/10/24.
//

import SwiftUI
import WidgetKit

@main
struct Expense_TrackerApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .onAppear {
                    WidgetCenter.shared.reloadAllTimelines()
                }
        }
        .modelContainer(for: [Transaction.self])
    }
}
