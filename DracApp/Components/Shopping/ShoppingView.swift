//
//  ShoppingView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 11.08.2024.
//

import SwiftUI

struct ShoppingView: View {
    @Binding var isShowingShop: Bool
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 16) {
                    // 5 kere tekrar eden ShoppingItemView
                    ForEach(0..<5) { _ in
                        ShoppingItemView()
                            .padding() 
                    }
                }
                .padding()
                .navigationTitle("Shopping")
                .navigationBarItems(trailing: Button("Kapat") {
                    isShowingShop = false
                })
            }
        }
    }
}

#Preview {
    ShoppingView(isShowingShop: .constant(true))
}
