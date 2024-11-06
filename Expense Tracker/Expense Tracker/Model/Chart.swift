//
//  Chart.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 6/11/24.
//

import SwiftUI

struct ChartGroup: Identifiable {
    let id = UUID()
    let date: Date
    let categories: [ChartCategory]
    let totalIncome: Double
    let totalExpense: Double
}

struct ChartCategory: Identifiable {
    let id = UUID()
    let category: Category
    let totalValue: Double
}
