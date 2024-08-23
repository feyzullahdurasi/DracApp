//
//  RadioView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 22.08.2024.
//

import SwiftUI

struct RadioView: View {
    @ObservedObject var bluetoothManager = BluetoothManager()

    var body: some View {
        VStack {
            Text("Bluetooth Radio Data")
                .font(.largeTitle)
                .padding()
            
            Text(bluetoothManager.radioData)
                .font(.title)
                .padding()
            
            // Daha fazla kontrol veya bilgi ekleyebilirsiniz
        }
    }
}

#Preview {
    RadioView()
}
