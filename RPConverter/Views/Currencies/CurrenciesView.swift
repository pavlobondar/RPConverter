//
//  CurrenciesView.swift
//  RPConverter
//
//  Created by Pavlo on 11.07.2024.
//

import SwiftUI

struct CurrenciesView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject private var viewModel = CurrenciesViewModel()
    
    @Binding var selectedCurrency: RPCurrency?
    
    var body: some View {
        VStack(spacing: 30) {
            Capsule(style: .continuous)
                .fill(Color(.systemGray4))
                .frame(width: 45, height: 6)
                .padding(.top, 5)
            
            Text("Sending to")
                .font(.system(size: 32, weight: .bold))
            
            Group {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color(uiColor: .systemGray3), lineWidth: 0.5)
                        .frame(height: 50)
                        .overlay {
                            HStack(alignment: .center, spacing: 10) {
                                Image(systemName: "magnifyingglass")
                                TextField("", text: $viewModel.query)
                                    .textInputAutocapitalization(.words)
                            }
                            .padding(.horizontal)
                        }
                    
                    Text("Search")
                        .padding(.horizontal, 5)
                        .background(Color(uiColor: .systemBackground))
                        .offset(x: 13, y: -25)
                }
                .foregroundColor(Color(uiColor: .lightGray))
                
                Text("All countries")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 19, weight: .bold))
            }
            .padding(.horizontal)
            
            List(viewModel.currencies, id: \.rawValue) { currency in
                VStack(alignment: .leading) {
                    CountryCellView(viewModel: .init(currency: currency))
                    Capsule()
                        .fill(Color(uiColor: .systemGray5))
                        .frame(height: 0.5)
                }
                .listRowSeparator(.hidden)
                .onTapGesture {
                    selectedCurrency = currency
                    dismiss()
                }
            }
            .listStyle(.plain)
            .scrollBounceBehavior(.basedOnSize)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

#Preview {
    @State var currency = RPCurrency(rawValue: "UAH")
    return CurrenciesView(selectedCurrency: $currency)
}
