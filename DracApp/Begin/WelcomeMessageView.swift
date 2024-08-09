//
//  WelcomeMessageView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 5.08.2024.
//

import SwiftUI

struct WelcomeMessageView: View {
    @Binding var isVisible: Bool
    var userName: String

    var body: some View {
        VStack {
            Spacer()
            Text("Merhaba, \(userName)!")
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.5))
                .foregroundColor(.white)
                .cornerRadius(10)
                .offset(y: isVisible ? 0 : UIScreen.main.bounds.height)
                .animation(.easeInOut(duration: 0.5), value: isVisible)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .transition(.opacity)
    }
}


#Preview {
    WelcomeMessageView(isVisible: .constant(true), userName: "Feyzullah Durası")
}
