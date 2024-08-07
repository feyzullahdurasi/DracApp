//
//  SettingsView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 5.08.2024.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isShowing: Bool // Bu sayfa görünümünü kontrol etmek için

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Genel Ayarlar")) {
                    Toggle("Dark Mode", isOn: .constant(true))
                    Toggle("Bildirimler", isOn: .constant(false))
                }
                
                Section(header: Text("Hesap")) {
                    Text("Kullanıcı Adı: \(UserDefaults.standard.string(forKey: "userName") ?? "Bilinmiyor")")
                    Button("Çıkış Yap") {
                        // Çıkış yapma işlemini burada yönetebilirsiniz
                        print("Çıkış yap butonuna tıklandı")
                    }
                }
            }
            .navigationTitle("Ayarlar")
            .navigationBarItems(trailing: Button("Kapat") {
                isShowing = false
            })
        }
    }
}


#Preview {
    SettingsView(isShowing: .constant(true))
}
