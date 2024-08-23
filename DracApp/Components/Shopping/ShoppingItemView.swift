//
//  ShoppingItemView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 11.08.2024.
//

import SwiftUI

struct ShoppingItemView: View {
    
    var body: some View {
        HStack{
            //image
            Image("TelefonTutucu")
                .resizable()
                .frame(width: 120, height: 120)
            // details
            HStack (alignment: .top){
                Text("Magsafe özelliğine sahip telefon tutucu")
                Spacer()
                VStack(spacing: 35) {
                    Text("190 ₺")
                        .foregroundColor(.init(red: 0.1, green: 0.3, blue: 0.3))
                        
                }
            }
        }
        .foregroundColor(.black)
        
    }
}

#Preview {
    ShoppingItemView()
}
