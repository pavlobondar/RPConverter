//
//  ConverterView.swift
//  RPConverter
//
//  Created by Pavlo on 11.07.2024.
//

import SwiftUI

struct ConverterView: View {

    @ObservedObject private var viewModel = ConverterViewModel()
    
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                baseCardView
                targetCardView
            }
            .fixedSize(horizontal: false, vertical: true)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(uiColor: .systemGray6))
                    .shadow(color: .black.opacity(0.1), radius: 5)
            }
            .overlay {
                GeometryReader { geometry in
                    ZStack {
                        Text(viewModel.conversion.exchangeRate)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.init(top: 3, leading: 8, bottom: 3, trailing: 8))
                            .contentTransition(.interpolate)
                            .background(
                                Capsule()
                                    .fill(.black)
                        )
                        
                        Button(action: {
                            viewModel.switchCurrencies()
                        }, label: {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.caption2)
                                .foregroundColor(.white)
                                .padding(7)
                                .background(
                                    Circle()
                                        .fill(.blue)
                                )
                        })
                        .frame(width: 25, height: 25)
                        .position(.init(x: geometry.size.width / 6, y: geometry.size.height / 2))
                    }
                }
            }
            
            if viewModel.validation == .exceedsMax {
                Label(viewModel.conversion.from.maxAmountMessage, systemImage: "info.circle")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 15))
                    .foregroundColor(.pink)
                    .padding(.init(top: 8, leading: 12, bottom: 8, trailing: 12))
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.red.opacity(0.2))
                    }
            }
            
            Spacer()
        }
        .padding(.init(top: 30, leading: 20, bottom: 30, trailing: 20))
        .onChange(of: networkMonitor.isActive) { isActive in
            viewModel.updateConnectionState(isActive: isActive)
        }
        .sheet(isPresented: $viewModel.isModalActive, onDismiss: {
            hideKeyboard()
        }) {
            CurrenciesView(selectedCurrency: $viewModel.selectedCurrency)
        }
        .toastView(toast: $viewModel.toast)
    }
    
    var baseCardView: some View {
        HStack {
            Button(action: {
                viewModel.updateBaseCurrency()
            }, label: {
                CurrencyInfoView(type: .base(viewModel.conversion.from))
            })
            
            Spacer()
            
            CurrencyTextField(
                value: $viewModel.amount,
                textColor: viewModel.validation == .exceedsMax ? .systemPink : .systemBlue,
                font: .systemFont(ofSize: 38, weight: .heavy))
        }
        .padding(.horizontal)
        .background(Color.white)
        .overlay(content: {
            if viewModel.validation == .exceedsMax {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(uiColor: .systemPink), lineWidth: 3)
            }
        })
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    var targetCardView: some View {
        HStack {
            Button(action: {
                viewModel.updateTargetCurrency()
            }, label: {
                CurrencyInfoView(type: .target(viewModel.conversion.to))
            })
            
            Spacer()
            
            Text(viewModel.conversion.formattedToAmount)
                .font(.system(size: 38, weight: .heavy))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .contentTransition(.numericText())
                .animation(.snappy, value: viewModel.conversion.formattedToAmount)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ConverterView()
}
