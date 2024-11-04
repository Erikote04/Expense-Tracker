//
//  Transaction.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 30/10/24.
//

import SwiftData
import SwiftUI

@Model
class Transaction {
    var title: String
    var remarks: String
    var amount: Double
    var date: Date
    var category: String
    var tintColor: String
    
    init(title: String, remarks: String, amount: Double, date: Date, category: Category, tintColor: TintColor) {
        self.title = title
        self.remarks = remarks
        self.amount = amount
        self.date = date
        self.category = category.rawValue
        self.tintColor = tintColor.color
    }
    
    @Transient
    var rawCategory: Category? {
        Category.allCases.first(where: { $0.rawValue == category })
    }
    
    @Transient
    var color: Color {
        tints.first(where: { $0.color == tintColor })?.value ?? appTint
    }
    
    @Transient
    var tint: TintColor? {
        tints.first(where: { $0.color == tintColor })
    }
}
