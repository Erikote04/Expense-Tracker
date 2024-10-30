//
//  Date+Extension.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 30/10/24.
//

import SwiftUI

extension Date {
    
    var startOfMonth: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self)) ?? self
    }
    
    var endOfMonth: Date {
        Calendar.current.date(byAdding: .init(month: 1, minute: -1), to: self.startOfMonth) ?? self
    }
}
