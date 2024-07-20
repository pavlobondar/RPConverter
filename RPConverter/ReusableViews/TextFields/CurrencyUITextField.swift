//
//  FormattedTextField.swift
//  RPConverter
//
//  Created by Pavlo on 15.07.2024.
//

import SwiftUI
import UIKit

final class CurrencyUITextField: UITextField {
    private var numberFormatter: NumberFormatter = {
        return NumberFormatterService.amountFormatter
    }()
    
    private var roundingPlaces: Int {
        return numberFormatter.maximumFractionDigits
    }
    
    private var amountAsDouble: Double?
    private var maxLength: Int
    
    @Binding private var value: Double
    
    init(value: Binding<Double>, maxLength: Int) {
        self._value = value
        self.maxLength = maxLength
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func closestPosition(to point: CGPoint) -> UITextPosition? {
        let beginning = self.beginningOfDocument
        let end = self.position(from: beginning, offset: self.text?.count ?? 0)
        return end
    }
    
    private func commonInit() {
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        delegate = self
        keyboardType = .numberPad
        textAlignment = .right
        minimumFontSize = 12
        adjustsFontSizeToFitWidth = true
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        updateText()
    }
    
    @objc private func textFieldDidChange() {
        updateTextField()
    }
    
    private func updateText() {
        let nsNumber = NSNumber(value: value)
        self.text = numberFormatter.string(from: nsNumber)
    }
    
    private func updateTextField() {
        let text = self.text ?? ""
        let cleanedAmount = text.filter({ $0.isNumber })
        
        if self.roundingPlaces > 0 {
            let amount = Double(cleanedAmount) ?? 0.0
            amountAsDouble = (amount / 100.0)
            let amountAsString = numberFormatter.string(from: NSNumber(value: amountAsDouble ?? 0.0)) ?? ""
            self.text = amountAsString
        } else {
            let amountAsNumber = Double(cleanedAmount) ?? 0.0
            amountAsDouble = amountAsNumber
            self.text = numberFormatter.string(from: NSNumber(value: amountAsNumber)) ?? ""
        }
        
        guard let amount = amountAsDouble else { return }
        value = amount
    }
}

// MARK: - UITextFieldDelegate
extension CurrencyUITextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text ?? "") as NSString
        let text = currentText.replacingCharacters(in: range, with: string)
        return text.count <= maxLength
    }
}
