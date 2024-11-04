//
//  SearchView.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 30/10/24.
//

import Combine
import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    @State private var filterText: String = ""
    
    let searchPublisher = PassthroughSubject<String, Never>()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 12) {
                    
                }
            }
            .navigationTitle("Search")
            .background(.gray.opacity(0.15))
            .searchable(text: $searchText)
            .onChange(of: searchText) { oldValue, newValue in
                if newValue.isEmpty { filterText = "" }
                searchPublisher.send(searchText)
            }
            .onReceive(searchPublisher.debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)) { text in
                filterText = text
            }
            .overlay {
                ContentUnavailableView("Search Transactions", systemImage: "magnifyingglass")
                    .opacity(searchText.isEmpty ? 1 : 0)
            }
        }
    }
}

#Preview {
    SearchView()
}
