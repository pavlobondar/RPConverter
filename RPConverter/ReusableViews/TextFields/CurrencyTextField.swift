//
//  CurrencyTextField.swift
//  RPConverter
//
//  Created by Pavlo on 15.07.2024.
//

import SwiftUI

struct CurrencyTextField: UIViewRepresentable {
    typealias UIViewType = CurrencyUITextField
    
    private var maxLength: Int
    private var textColor: UIColor
    private var font: UIFont
    
    @Binding private var value: Double
    
    init(value: Binding<Double>, textColor: UIColor, font: UIFont, maxLength: Int = 11) {
        self._value = value
        self.textColor = textColor
        self.font = font
        self.maxLength = maxLength
    }
    
    func makeUIView(context: Context) -> CurrencyUITextField {
        let currencyField = CurrencyUITextField(value: $value, maxLength: maxLength)
        return currencyField
    }
    
    func updateUIView(_ uiView: CurrencyUITextField, context: Context) {
        uiView.font = font
        uiView.textColor = textColor
    }
}
