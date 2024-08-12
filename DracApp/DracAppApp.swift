//
//  DracAppApp.swift
//  DracApp
//
//  Created by Feyzullah Durası on 2.08.2024.
//

import SwiftUI

@main
struct DracApp: App {
    @StateObject private var viewModel = MainViewModel() // ViewModel'inizi tanımlayın

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(viewModel) // ViewModel'i ortama ekleyin
                .onOpenURL { url in
                    viewModel.handleURL(url: url)
                }
        }
    }
}
