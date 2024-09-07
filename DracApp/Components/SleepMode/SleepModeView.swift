//
//  SleepModeView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 22.08.2024.
//

import SwiftUI
import Combine

struct SleepModeView: View {
    @Binding var isShowingSleepMode: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                // Arka planı siyah yap
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                // Analog saat
                AnalogClockView()
                    .frame(width: 200, height: 200)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isShowingSleepMode = false
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .bold))
                    }
                }
            }
        }
    }
}

struct AnalogClockView: View {
    @StateObject private var clockManager = ClockManager()
    
    var body: some View {
        ZStack {
            // Saatin dış çerçevesi
            Circle()
                .stroke(Color.white, lineWidth: 4)
                .background(Circle().fill(Color.black))
                .shadow(radius: 10)
            
            
            // Saat kolları
            HourHand(hour: clockManager.hour)
                .stroke(Color.white, lineWidth: 4)
                .frame(width: 2, height: 60)
            
            MinuteHand(minute: clockManager.minute)
                .stroke(Color.white, lineWidth: 2)
                .frame(width: 2, height: 80)
            
            SecondHand(second: clockManager.second)
                .stroke(Color.red, lineWidth: 1)
                .frame(width: 1, height: 90)
        }
    }
}

struct HourHand: Shape {
    let hour: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let angle = (hour / 12) * 360 - 90
        let radians = Angle.degrees(angle).radians
        
        path.move(to: center)
        path.addLine(to: CGPoint(
            x: center.x + cos(radians) * 50,
            y: center.y + sin(radians) * 50
        ))
        
        return path
    }
}

struct MinuteHand: Shape {
    let minute: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let angle = (minute / 60) * 360 - 90
        let radians = Angle.degrees(angle).radians
        
        path.move(to: center)
        path.addLine(to: CGPoint(
            x: center.x + cos(radians) * 70,
            y: center.y + sin(radians) * 70
        ))
        
        return path
    }
}

struct SecondHand: Shape {
    let second: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let angle = (second / 60) * 360 - 90
        let radians = Angle.degrees(angle).radians
        
        path.move(to: center)
        path.addLine(to: CGPoint(
            x: center.x + cos(radians) * 85,
            y: center.y + sin(radians) * 85
        ))
        
        return path
    }
}

class ClockManager: ObservableObject {
    @Published var hour: Double = 0
    @Published var minute: Double = 0
    @Published var second: Double = 0
    
    private var timer: Timer?
    
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute, .second], from: Date())
            self.hour = Double(components.hour ?? 0) + (Double(components.minute ?? 0) / 60)
            self.minute = Double(components.minute ?? 0) + (Double(components.second ?? 0) / 60)
            self.second = Double(components.second ?? 0)
        }
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY - 100))
        return path
    }
}

#Preview {
    SleepModeView(isShowingSleepMode: .constant(true))
}
