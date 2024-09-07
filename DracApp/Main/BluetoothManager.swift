//
//  BluetoothManager.swift
//  DracApp
//
//  Created by Feyzullah Durası on 23.08.2024.
//

import SwiftUI
import CoreBluetooth
import UserNotifications

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var radioData: String = "No Data"
    
    private var centralManager: CBCentralManager!
    private var connectedPeripheral: CBPeripheral?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        requestNotificationPermission()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            // Bluetooth açık, taramayı başlat
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            // Bluetooth kapalı, hata mesajı gösterebilirsiniz
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Bluetooth cihazı bulundu, bağlanın
        centralManager.stopScan()
        connectedPeripheral = peripheral
        connectedPeripheral?.delegate = self
        centralManager.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // Bağlantı başarılı, hizmetleri keşfet
        peripheral.discoverServices(nil)
        showNotification(title: "Bağlantı Başarılı", body: "Bluetooth cihazına bağlandınız.", shouldOpenApp: true)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                // Hizmetleri keşfedin, uygun hizmet için özellikleri keşfedin
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                // Özellikleri okuyun veya bildirimleri etkinleştirin
                peripheral.readValue(for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value {
            // Veriyi işleyin
            radioData = String(data: data, encoding: .utf8) ?? "Invalid Data"
        }
    }

    // Bildirim izni isteyin
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Bildirim izni reddedildi: \(error.localizedDescription)")
            }
        }
    }

    // Bildirim gösterme fonksiyonu
    private func showNotification(title: String, body: String, shouldOpenApp: Bool = false) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        // Kullanıcı bildirime tıkladığında uygulamaya yönlendirilecek
        if shouldOpenApp {
            content.categoryIdentifier = "BLUETOOTH_NOTIFICATION"
            let openAppAction = UNNotificationAction(identifier: "OPEN_APP", title: "Uygulamayı Aç", options: .foreground)
            let category = UNNotificationCategory(identifier: "BLUETOOTH_NOTIFICATION", actions: [openAppAction], intentIdentifiers: [], options: [])
            UNUserNotificationCenter.current().setNotificationCategories([category])
        }

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim gösterilemedi: \(error.localizedDescription)")
            }
        }
    }
}
