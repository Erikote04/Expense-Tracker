//
//  DateFilterView.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 31/10/24.
//

import SwiftUI

struct DateFilterView: View {
    @State var start: Date
    @State var end: Date
    
    var onSubmit: (Date, Date) -> Void
    var onClose: () -> ()
    
    var body: some View {
        VStack(spacing: 16) {
            DatePicker("Start Date", selection: $start, displayedComponents: [.date])
            
            DatePicker("End Date", selection: $end, displayedComponents: [.date])
            
            HStack(spacing: 16) {
                Button("Cancel") {
                    onClose()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 4))
                .tint(.red)
                
                Button("Filter") {
                    onSubmit(start, end)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 4))
                .tint(appTint)
            }
            .padding(.top, 8)
        }
        .padding(16)
        .background(.bar, in: .rect(cornerRadius: 8))
        .padding(.horizontal, 32)
    }
}
