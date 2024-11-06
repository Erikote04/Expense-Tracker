//
//  CardView.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 30/10/24.
//

import SwiftUI

struct CardView: View {
    let income: Double
    let expense: Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.background)
            
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Text("\(currency(income - expense))")
                        .font(.title.bold())
                        .foregroundStyle(Color.primary)
                    
                    Image(
                        systemName: expense > income ?
                        "chart.line.downtrend.xyaxis" :
                        "chart.line.uptrend.xyaxis"
                    )
                    .font(.title3)
                    .foregroundStyle(expense > income ? .red : .green)
                }
                .padding(.bottom, 24)
                
                HStack(spacing: 0) {
                    ForEach(Category.allCases, id: \.rawValue) { category in
                        let symbolImage = category == .income ? "arrow.down" : "arrow.up"
                        let tint = category == .income ? Color.green : Color.red
                        
                        HStack(spacing: 8) {
                            Image(systemName: symbolImage)
                                .font(.callout.bold())
                                .foregroundStyle(tint)
                                .frame(width: 32, height: 32)
                                .background {
                                    Circle()
                                        .fill(tint.opacity(0.25).gradient)
                                }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(category.rawValue)
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                                
                                Text(currency(category == .income ? income : expense, allowedDigits: 0))
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.primary)
                            }
                            
                            if category == .income {
                                Spacer(minLength: 8)
                            }
                        }
                    }
                }
            }
            .padding([.horizontal, .bottom], 24)
            .padding(.top, 16)
        }
    }
}

#Preview {
    ScrollView {
        CardView(income: 1250, expense: 350)
    }
}
