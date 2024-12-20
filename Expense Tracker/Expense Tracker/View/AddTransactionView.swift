//
//  AddExpenseView.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 4/11/24.
//

import SwiftUI
import WidgetKit

struct AddTransactionView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var remarks: String = ""
    @State private var amount: Double = .zero
    @State private var date: Date = .now
    @State private var category: Category = .expense
    
    var editTransaction: Transaction?
    
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 16) {
                Text("Preview")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .horizontalSpacing(.leading)
                
                TransactionCardView(transaction: .init(
                    title: title.isEmpty ? "Title" : title,
                    remarks: remarks.isEmpty ? "Remarks" : remarks,
                    amount: amount,
                    date: date,
                    category: category
                ))
                
                CustomSection("Title", "Transaction Title", value: $title)
                
                CustomSection("Remarks", "Transaction Remarks", value: $remarks)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Amount & Category")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .horizontalSpacing(.leading)
                    
                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Text(currencySymbol)
                                .font(.callout.bold())
                            
                            TextField("0.0", value: $amount, formatter: numberFormatter)
                                .keyboardType(.decimalPad)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.background, in: .rect(cornerRadius: 8))
                        .frame(maxWidth: 128)
                        
                        Checkbox()
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .horizontalSpacing(.leading)
                    
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.background, in: .rect(cornerRadius: 8))
                }
            }
            .padding(16)
        }
        .navigationTitle("\(editTransaction == nil ? "Add" : "Edit") Transaction")
        .navigationBarTitleDisplayMode(.inline)
        .background(.gray.opacity(0.15))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: save)
            }
        }
        .onAppear {
            if let editTransaction {
                title = editTransaction.title
                remarks = editTransaction.remarks
                amount = editTransaction.amount
                date = editTransaction.date
                
                if let category = editTransaction.rawCategory {
                    self.category = category
                }
            }
        }
    }
    
    func save() {
        if editTransaction != nil {
            editTransaction?.title = title
            editTransaction?.remarks = remarks
            editTransaction?.amount = amount
            editTransaction?.date = date
            editTransaction?.category = category.rawValue
        } else {
            let transaction = Transaction(
                title: title,
                remarks: remarks,
                amount: amount,
                date: date,
                category: category
            )
            
            context.insert(transaction)
        }
        
        dismiss()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    @ViewBuilder
    func CustomSection(_ title: String, _ hint: String, value: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
                .horizontalSpacing(.leading)
            
            TextField(hint, text: value)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.background, in: .rect(cornerRadius: 8))
        }
    }
    
    @ViewBuilder
    func Checkbox() -> some View {
        HStack(spacing: 8) {
            ForEach(Category.allCases, id: \.rawValue) { category in
                HStack(spacing: 5) {
                    ZStack {
                        Image(systemName: "circle")
                            .font(.title3)
                            .foregroundStyle(appTint)
                        
                        if self.category == category {
                            Image(systemName: "circle.fill")
                                .font(.caption)
                                .foregroundStyle(appTint)
                        }
                    }
                    
                    Text(category.rawValue)
                        .font(.caption)
                }
                .contentShape(.rect)
                .onTapGesture {
                    self.category = category
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .horizontalSpacing(.leading)
        .background(.background, in: .rect(cornerRadius: 8))
    }
}

#Preview {
    NavigationStack {
        AddTransactionView()
    }
}
