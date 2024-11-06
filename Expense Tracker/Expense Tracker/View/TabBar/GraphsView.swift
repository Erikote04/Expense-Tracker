//
//  ChartsView.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 30/10/24.
//

import Charts
import SwiftData
import SwiftUI

struct GraphsView: View {
    @Query(animation: .snappy) private var transactions: [Transaction]
    
    @State private var chartGroups: [ChartGroup] = []
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 8) {
                    ChartView()
                        .frame(height: 200)
                        .padding(8)
                        .padding(.top, 8)
                        .background(.background, in: .rect(cornerRadius: 8))
                    
                    ForEach(chartGroups) { group in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(format(date: group.date, format: "MMM yy"))
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .horizontalSpacing(.leading)
                            
                            NavigationLink {
                                ListOfExpenses(month: group.date)
                            } label: {
                                CardView(income: group.totalIncome, expense: group.totalExpense)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(16)
            }
            .navigationTitle("Graphs")
            .background(.gray.opacity(0.15))
            .onAppear {
                createChartGroups()
            }
        }
    }
    
    @ViewBuilder
    func ChartView() -> some View {
        Chart {
            ForEach(chartGroups) { group in
                ForEach(group.categories) { chart in
                    BarMark(
                        x: .value("Month", format(date: group.date, format: "MMM yy")),
                        y: .value(chart.category.rawValue, chart.totalValue),
                        width: 20
                    )
                    .position(by: .value("Category", chart.category.rawValue), axis: .horizontal)
                    .foregroundStyle(by: .value("Category", chart.category.rawValue))
                }
            }
        }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 4)
        .chartLegend(position: .bottom, alignment: .trailing)
        .chartYAxis { value in
            let doubleValue = value.as(Double.self) ?? 0
            
            AxisGridLine()
            AxisTick()
            AxisMark(position: .leading) {
                Text(axisLabel(doubleValue))
            }
        }
        .chartForegroundStyleScale(range: [Color.green.gradient, Color.red.gradient])
    }
    
    func createChartGroups() {
        Task.detached(priority: .high) {
            let calendar = Calendar.current
            
            let groupedDate = Dictionary(grouping: transactions) { transaction in
                return calendar.dateComponents([.month, .year], from: transaction.date)
            }
            
            let sortedGroups = groupedDate.sorted {
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                
                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
            }
            
            let chartGroups = sortedGroups.compactMap { (dict) -> ChartGroup? in
                let date = calendar.date(from: dict.key) ?? .init()
                let income = dict.value.filter { $0.category == Category.income.rawValue }
                let expense = dict.value.filter { $0.category == Category.expense.rawValue }
                let incomeTotalValue = total(income, category: .income)
                let expenseTotalValue = total(expense, category: .income)
                
                return .init(
                    date: date,
                    categories: [
                        .init(category: .income, totalValue: incomeTotalValue),
                        .init(category: .expense, totalValue: expenseTotalValue)
                    ],
                    totalIncome: incomeTotalValue,
                    totalExpense: expenseTotalValue
                )
            }
            
            await MainActor.run {
                self.chartGroups = chartGroups
            }
        }
    }
    
    func axisLabel(_ value: Double) -> String {
        let intValue = Int(value)
        let kValue = intValue / 1000
        
        return intValue < 1000 ? "\(intValue)" : "\(kValue)K"
    }
}

struct ListOfExpenses: View {
    let month: Date
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16) {
                Section {
                    FilterTransactionsView(
                        startDate: month.startOfMonth,
                        endDate: month.endOfMonth,
                        category: .income
                    ) { transactions in
                        ForEach(transactions) { transaction in
                            NavigationLink {
                                AddTransactionView(editTransaction: transaction)
                            } label: {
                                TransactionCardView(transaction: transaction)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } header: {
                    Text("Income")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .horizontalSpacing(.leading)
                }
                
                Section {
                    FilterTransactionsView(
                        startDate: month.startOfMonth,
                        endDate: month.endOfMonth,
                        category: .expense
                    ) { transactions in
                        ForEach(transactions) { transaction in
                            NavigationLink {
                                AddTransactionView(editTransaction: transaction)
                            } label: {
                                TransactionCardView(transaction: transaction)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } header: {
                    Text("Expense")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .horizontalSpacing(.leading)
                }
            }
            .padding(16)
        }
        .background(.gray.opacity(0.15))
        .navigationTitle(format(date: month, format: "MMM yy"))
    }
}

#Preview {
    GraphsView()
}
