//
//  Transaction.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 30/10/24.
//

import SwiftUI

struct Transaction: Identifiable {
    let id: UUID = .init()
    let title: String
    let remarks: String
    let amount: Double
    let date: Date
    let category: String
    let tintColor: String
    
    init(title: String, remarks: String, amount: Double, date: Date, category: Category, tintColor: TintColor) {
        self.title = title
        self.remarks = remarks
        self.amount = amount
        self.date = date
        self.category = category.rawValue
        self.tintColor = tintColor.color
    }
    
    var color: Color {
        tints.first(where: { $0.color == tintColor })?.value ?? appTint
    }
}
