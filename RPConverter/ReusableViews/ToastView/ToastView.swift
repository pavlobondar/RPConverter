//
//  ToastView.swift
//  RPConverter
//
//  Created by Pavlo on 17.07.2024.
//

import SwiftUI

struct ToastView: View {
    
    var error: EndpointError
    var onCancelTapped: (() -> Void)
    
    var body: some View {
        HStack(alignment: .top, spacing: 21) {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 35, height: 35)
                .foregroundStyle(Color(uiColor: .systemPink))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(error.title)
                    .font(.system(size: 18, weight: .bold))
                    .lineLimit(1)
                
                Text(error.description)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color.gray)
            }
            
            Spacer()
            
            Button(action: {
                onCancelTapped()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundStyle(Color.gray)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
            })
        }
        .padding(15)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

#Preview {
    ToastView(error: .invalidData, onCancelTapped: {})
}
