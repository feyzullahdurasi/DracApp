//
//  SettingsView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 5.08.2024.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isShowing: Bool
    @Binding var selectedStreamingService: StreamingService
    @State private var areNotificationsEnabled: Bool = UserDefaults.standard.bool(forKey: "areNotificationsEnabled")
    @State private var changeTheme: Bool = false
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @State private var userName: String = UserDefaults.standard.string(forKey: "userName") ?? ""
    @State private var isEditingUserName: Bool = false
    @State private var speedUnitIndex: Int = UserDefaults.standard.integer(forKey: "speedUnitIndex")
    //@State private var selectedLanguage: Language = Language(rawValue: UserDefaults.standard.string(forKey: "selectedLanguage") ?? "English") ?? .english
    
    var body: some View {
        NavigationStack {
            List {
                Section("Appearance"){
                    Picker(selection: $speedUnitIndex, label: Text("System")) {
                        Text("km/s").tag(0)
                        Text("mph").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: speedUnitIndex) { newValue, _ in
                        UserDefaults.standard.set(newValue, forKey: "speedUnitIndex")
                    }
                    
                    Toggle("Notifications", isOn: $areNotificationsEnabled)
                        .onChange(of: areNotificationsEnabled) { newValue, _ in
                            // Bildirimler ayarını UserDefaults'a kaydet
                            UserDefaults.standard.set(newValue, forKey: "areNotificationsEnabled")
                        }
                    
                    Button("Chose Theme") {
                        changeTheme.toggle()
                    }
                    .preferredColorScheme(userTheme.colorSheme)
                    
                    Picker(selection: $selectedStreamingService, label: Text("Streaming Service")) {
                        Text("YouTube Music").tag(StreamingService.youtubeMusic)
                        Text("Spotify").tag(StreamingService.spotify)
                        Text("Apple Music").tag(StreamingService.appleMusic)
                        Text("Radio").tag(StreamingService.appleMusic)
                    }
                    //.pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedStreamingService) { newValue, _ in
                        let serviceString: String
                        switch newValue {
                        case .spotify:
                            serviceString = "spotify"
                        case .youtubeMusic:
                            serviceString = "youtubeMusic"
                        case .appleMusic:
                            serviceString = "appleMusic"
                        case .radio:
                            serviceString = "radio"
                        }
                        UserDefaults.standard.set(serviceString, forKey: "preferredStreamingService")
                    }
                }
                
                /*Section(header: Text("Dil Ayarı")) {
                    Picker("Select Language", selection: $selectedLanguage) {
                        ForEach(Language.allCases) { language in
                            Text(language.displayName).tag(language)
                        }
                    }
                    .onChange(of: selectedLanguage) { newValue, _ in
                        UserDefaults.standard.set(newValue.rawValue, forKey: "selectedLanguage")
                        // Dil değişimi işlemleri burada yapılabilir
                    }
                }*/
                
                Section(header: Text("User Account")) {
                    HStack {
                        if isEditingUserName {
                            TextField("User name", text: $userName, onCommit: {
                                // Kullanıcı adı değiştiğinde UserDefaults'a kaydet
                                UserDefaults.standard.set(userName, forKey: "userName")
                                isEditingUserName = false
                            })
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                        } else {
                            Text("User Name: \(userName)")
                                .padding()
                            Spacer()
                            Button("Edit") {
                                isEditingUserName = true
                            }
                        }
                    }
                    
                    Button("Log Out") {
                        // Çıkış yapma işlemini burada yönetebilirsiniz
                        print("The logout button was clicked")
                        // UserDefaults'tan kullanıcı bilgilerini temizleyebilirsiniz
                        UserDefaults.standard.removeObject(forKey: "userName")
                        userName = "" // Kullanıcı adı state'ini sıfırla
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Close") {
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
    SettingsView(isShowing: .constant(true), selectedStreamingService: .constant(.spotify))
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
/*
enum Language: String, CaseIterable, Identifiable {
    case english = "English"
    case turkish = "Türkçe"
    case german = "Deutsch"
    case french = "Français"
    
    var id: String { self.rawValue }
    
    // Display adını yerelleştir
    var displayName: LocalizedStringKey {
        switch self {
        case .english:
            return LocalizedStringKey("english")
        case .turkish:
            return LocalizedStringKey("turkish")
        case .german:
            return LocalizedStringKey("german")
        case .french:
            return LocalizedStringKey("french")
        }
    }
}*/
