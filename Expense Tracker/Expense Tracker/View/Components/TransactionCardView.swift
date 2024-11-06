//
//  TransactionCardView.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 31/10/24.
//

import SwiftUI

struct TransactionCardView: View {
    let transaction: Transaction
    var isShowingCategory: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            Text("\(String(transaction.title.prefix(1)))")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(transaction.color.gradient, in: .circle)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .foregroundStyle(.primary)
                
                Text(transaction.remarks)
                    .font(.caption)
                    .foregroundStyle(.primary.secondary)
                
                Text(format(date: transaction.date, format: "dd MMM yyyy"))
                    .font(.caption2)
                    .foregroundStyle(.gray)
                
                if isShowingCategory {
                    Text(transaction.category)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .foregroundStyle(.white)
                        .background(
                            transaction.category == Category.income.rawValue ?
                            Color.green.gradient : Color.red.gradient,
                            in: .capsule
                        )
                }
            }
            .lineLimit(1)
            .horizontalSpacing(.leading)
            
            Text(currency(transaction.amount))
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.background, in: .rect(cornerRadius: 8))
    }
}

#Preview {
    HomeView()
}
