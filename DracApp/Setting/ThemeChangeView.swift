//
//  ThemeChangeView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 9.08.2024.
//

import SwiftUI

struct ThemeChangeView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @Namespace var animation
    var body: some View {
        VStack(spacing: 25) {
            Text("Choose a style")
                .font(.title)
            HStack(spacing: 0) {
                ForEach(Theme.allCases, id: \.rawValue) { theme in
                    Text(theme.rawValue)
                        .padding(.vertical, 10)
                        .frame(width: 100)
                        .background {
                            ZStack {
                                if userTheme == theme {
                                    Capsule()
                                        .fill(.gray)
                                        .matchedGeometryEffect(id: "ACTIVE", in: animation)
                                }
                            }
                            .animation(.snappy, value: userTheme)
                        }
                        .contentShape(.rect)
                        .onTapGesture {
                            userTheme = theme
                        }
                    
                }
            }
            .padding(3)
            .background(.primary.opacity(0.06), in: .capsule)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(height: 410)
        .background()
        .clipShape(.rect(cornerRadius: 30))
        .padding(.horizontal, 159)
    }
}

#Preview {
    ThemeChangeView()
}
