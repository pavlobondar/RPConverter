//
//  CountryCellView.swift
//  RPConverter
//
//  Created by Pavlo on 11.07.2024.
//

import SwiftUI

struct CountryCellView: View {
    var viewModel: CountryCellViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Circle()
                .fill(Color(uiColor: .systemGray6))
                .frame(width: 50, height: 50)
                .overlay {
                    Image(viewModel.image)
                        .resizable()
                        .padding(3)
                }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(viewModel.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                Text(viewModel.subtitle)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    CountryCellView(viewModel: .init(currency: .poland))
}
