//
//  View+Extension.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 30/10/24.
//

import SwiftUI

extension View {
    
    @available(iOSApplicationExtension, unavailable)
    var safeArea: UIEdgeInsets {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.keyWindow?.safeAreaInsets ?? .zero
        }
        
        return .zero
    }
    
    var currencySymbol: String {
        Locale.current.currencySymbol ?? ""
    }
    
    func format(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func currency(_ value: Double, allowedDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = allowedDigits
        return formatter.string(from: .init(value: value)) ?? ""
    }
    
    func total(_ transactions: [Transaction], category: Category) -> Double {
        return transactions
            .filter { $0.category == category.rawValue }
            .reduce(Double.zero) { partialResult, transaction in
                return partialResult + transaction.amount
            }
    }
    
    @ViewBuilder
    func horizontalSpacing(_ alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    func verticalSpacing(_ alignment: Alignment = .center) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
}
