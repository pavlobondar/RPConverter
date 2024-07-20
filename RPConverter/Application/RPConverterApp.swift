//
//  RPConverterApp.swift
//  RPConverter
//
//  Created by Pavlo on 11.07.2024.
//

import SwiftUI

@main
struct RPConverterApp: App {
    let monitor = NetworkMonitor()
    var body: some Scene {
        WindowGroup {
            ConverterView()
                .environmentObject(monitor)
        }
    }
}
