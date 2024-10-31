//
//  LockType.swift
//  Expense Tracker
//
//  Created by Erik Sebastian de Erice Jerez on 31/10/24.
//

import SwiftUI

enum LockType: String {
    case biometric = "Bio Metric Auth"
    case pin = "Custom Pin Lock"
    case both = "First preference will be biometric, if it's not available, it will go for pin lock."
}
