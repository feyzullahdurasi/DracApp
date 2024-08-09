//
//  SettingsView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 5.08.2024.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isShowing: Bool
    
    @State private var areNotificationsEnabled: Bool = UserDefaults.standard.bool(forKey: "areNotificationsEnabled")
    @State private var changeTheme: Bool = false
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @State private var userName: String = UserDefaults.standard.string(forKey: "userName") ?? ""
    @State private var isEditingUserName: Bool = false
    @State private var speedUnitIndex: Int = UserDefaults.standard.integer(forKey: "speedUnitIndex")
    
    var body: some View {
        NavigationStack {
            List {
                Section("Appearance"){
                    Picker(selection: $speedUnitIndex, label: Text("System")) {
                        Text("km/s").tag(0)
                        Text("mph").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: speedUnitIndex) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "speedUnitIndex")
                    }
                    
                    Toggle("Bildirimler", isOn: $areNotificationsEnabled)
                        .onChange(of: areNotificationsEnabled) { newValue in
                            // Bildirimler ayarını UserDefaults'a kaydet
                            UserDefaults.standard.set(newValue, forKey: "areNotificationsEnabled")
                        }
                    
                    Button("Chose Theme") {
                        changeTheme.toggle()
                    }.preferredColorScheme(userTheme.colorSheme)
                }
                
                Section(header: Text("Hesap")) {
                    HStack {
                        if isEditingUserName {
                            TextField("Kullanıcı Adı", text: $userName, onCommit: {
                                // Kullanıcı adı değiştiğinde UserDefaults'a kaydet
                                UserDefaults.standard.set(userName, forKey: "userName")
                                isEditingUserName = false // Düzenleme modunu kapat
                            })
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                        } else {
                            Text("Kullanıcı Adı: \(userName)")
                                .padding()
                            Spacer()
                            Button("Düzenle") {
                                isEditingUserName = true // Düzenleme modunu aç
                            }
                        }
                    }
                    
                    Button("Çıkış Yap") {
                        // Çıkış yapma işlemini burada yönetebilirsiniz
                        print("Çıkış yap butonuna tıklandı")
                        // UserDefaults'tan kullanıcı bilgilerini temizleyebilirsiniz
                        UserDefaults.standard.removeObject(forKey: "userName")
                        userName = "" // Kullanıcı adı state'ini sıfırla
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Kapat") {
                isShowing = false
            })
        }.sheet(isPresented: $changeTheme, content: {
            ThemeChangeView()
                .presentationDetents([.height(410)])
                .presentationBackground(.clear)
        })
    }
}

#Preview {
    SettingsView(isShowing: .constant(true))
}

enum Theme : String, CaseIterable {
    case systemDefault = "default"
    case light = "light"
    case dark = "dark"
    
    var colorSheme: ColorScheme? {
        switch self {
        case .systemDefault:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
