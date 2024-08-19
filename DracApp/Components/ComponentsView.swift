//
//  ComponentsView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 5.08.2024.
//

import SwiftUI

struct GenericView: View {
    @Binding var isShowing: Bool
    let title: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
        }
    }
}

struct ContactsView: View {
    @Binding var showContacts: Bool
    
    var body: some View {
        GenericView(isShowing: $showContacts, title: "Contacts View")
    }
}

struct InstagramView: View {
    @Binding var showInstagram: Bool
    
    var body: some View {
        GenericView(isShowing: $showInstagram, title: "Instagram View")
    }
}

