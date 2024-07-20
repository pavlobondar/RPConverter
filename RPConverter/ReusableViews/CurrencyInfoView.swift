//
//  CurrencyInfoView.swift
//  RPConverter
//
//  Created by Pavlo on 15.07.2024.
//

import SwiftUI

struct CurrencyInfoView: View {
    var type: InfoType
    
    var body: some View {
        VStack(spacing: 6) {
            Text(type.title)
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            HStack(alignment: .center, spacing: 6) {
                Image(type.image)
                    .resizable()
                    .frame(width: 35, height: 35)
                Text(type.name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.black)
                Image(systemName: "chevron.down")
                    .frame(width: 20)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 15)
    }
}

extension CurrencyInfoView {
    enum InfoType: Equatable {
        case base(RPCurrency)
        case target(RPCurrency)
        
        var title: String {
            switch self {
            case .base:
                return "Sending from"
            case .target:
                return "Receiver gets"
            }
        }
        
        var image: String {
            switch self {
            case .base(let currency), .target(let currency):
                return currency.imageName
            }
        }
        
        var name: String {
            switch self {
            case .base(let currency), .target(let currency):
                return currency.currency
            }
        }
    }
}

#Preview {
    CurrencyInfoView(type: .base(.germany))
}
