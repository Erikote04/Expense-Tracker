//
//  FilterTransactionsView.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 6/11/24.
//

import SwiftData
import SwiftUI

struct FilterTransactionsView<Content: View>: View {
    @Query(animation: .snappy) private var transactions: [Transaction]
    
    var content: ([Transaction]) -> Content
    
    init(category: Category?, searchText: String, @ViewBuilder content: @escaping ([Transaction]) -> Content) {
        let rawValue = category?.rawValue ?? ""
        let predicate = #Predicate<Transaction> { transaction in
            return (transaction.title.localizedStandardContains(searchText) ||
                    transaction.remarks.localizedStandardContains(searchText)) && (rawValue.isEmpty ? true : transaction.category == rawValue)
        }
        
        _transactions = Query(filter: predicate,
                              sort: [SortDescriptor(\Transaction.date, order: .reverse)],
                              animation: .snappy)
        
        self.content = content
    }
    
    var body: some View {
        content(transactions)
    }
}
