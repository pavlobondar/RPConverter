//
//  View+Keyboard.swift
//  RPConverter
//
//  Created by Pavlo on 17.07.2024.
//

import SwiftUI

extension View {
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
