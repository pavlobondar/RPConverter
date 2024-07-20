//
//  View+Toast.swift
//  RPConverter
//
//  Created by Pavlo on 17.07.2024.
//

import SwiftUI

extension View {

  func toastView(toast: Binding<Toast?>) -> some View {
    self.modifier(ToastModifier(toast: toast))
  }
}
