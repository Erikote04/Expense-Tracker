//
//  IntroductionView.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 30/10/24.
//

import SwiftUI

struct FirstTimeExperienceView: View {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    var body: some View {
        VStack(spacing: 16) {
            Text("What's New in the \nExpense Tracker")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 64)
                .padding(.bottom, 32)
            
            VStack(alignment: .leading, spacing: 24) {
                PointView(
                    symbol: "dollarsign",
                    title: "Transactions",
                    subTitle: "Keep track of your earnings and expenses."
                )
                
                PointView(
                    symbol: "chart.bar.fill",
                    title: "Visual Charts",
                    subTitle: "View your transactions using eye-catching graphic representations."
                )
                
                PointView(
                    symbol: "magnifyingglass",
                    title: "Advance Filters",
                    subTitle: "Find the expenses you want by advance search and filtering."
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            
            Spacer(minLength: 8)
            
            Button {
                isFirstTime = false
            } label: {
                Text("Continue")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(appTint.gradient, in: .rect(cornerRadius: 12))
                    .contentShape(.rect)
            }
        }
        .padding(16)
    }
    
    @ViewBuilder
    func PointView(symbol: String, title: String, subTitle: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(appTint)
                .frame(width: 48)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(subTitle)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    FirstTimeExperienceView()
}
