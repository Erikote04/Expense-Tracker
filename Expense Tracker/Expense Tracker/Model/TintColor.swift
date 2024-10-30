//
//  TintColor.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 30/10/24.
//

import SwiftUI

struct TintColor: Identifiable {
    let id: UUID = .init()
    let color: String
    let value: Color
}

let tints: [TintColor] = [
    .init(color: "Blue", value: .blue),
    .init(color: "Brown", value: .brown),
    .init(color: "Orange", value: .orange),
    .init(color: "Pink", value: .pink),
    .init(color: "Purple", value: .purple),
    .init(color: "Red", value: .red),
]
