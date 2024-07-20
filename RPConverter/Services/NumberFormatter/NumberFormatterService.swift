//
//  NumberFormatterService.swift
//  RPConverter
//
//  Created by Pavlo on 11.07.2024.
//

import Foundation

final class NumberFormatterService {
    static var amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = " "
        return formatter
    }()
    
    static func getFormattedAmount(_ amount: Double) -> String? {
        let number = NSNumber(value: amount)
        return amountFormatter.string(from: number)
    }
}
