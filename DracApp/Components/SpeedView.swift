//
//  SpeedView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 9.08.2024.
//

import SwiftUI
import CoreLocation

struct SpeedView: View {
    @Binding var showSpeed: Bool
    @StateObject private var locationManager1 = LocationManager1()
    @State private var timer: Timer?
    @State private var secondsRemaining = 5
    @State private var elapsedTime: TimeInterval = 0
    @State private var startTime: Date?
    @State private var countdownFinished = false
    @State private var countdownStarted = false
    @State private var countdownAnimationAmount: CGFloat = 1.0
    @State private var isScaled: Bool = false
    @AppStorage("speedUnitIndex") private var speedUnitIndex: Int = 0

    var body: some View {
        GeometryReader { geometry in
            VStack {
                if geometry.size.width > geometry.size.height {
                    // Landscape Layout
                    landscapeLayout(geometry: geometry)
                } else {
                    // Portrait Layout
                    portraitLayout(geometry: geometry)
                }
            }
            .onAppear {
                startTimer()
            }
            .onDisappear {
                timer?.invalidate()
            }
            .onReceive(timerPublisher) { _ in
                if countdownFinished, let startTime = startTime {
                    elapsedTime = Date().timeIntervalSince(startTime)
                }
            }
        }
    }

    private func landscapeLayout(geometry: GeometryProxy) -> some View {
        HStack {
            Spacer()
            Spacer()
            VStack {
                Text("Anlık Hız")
                    .font(.title)
                    .padding()
                let speedText = getSpeedText()
                Text(speedText)
                    .font(.title2)
                    .padding()
                
            }
            VStack{
                if countdownFinished {
                    Text("\(String(format: "%.2f", elapsedTime)) sn")
                        .font(.title3)
                        .padding()
                } else {
                    if countdownStarted {
                        Text("\(secondsRemaining)")
                            .font(.title)
                            .padding()
                            .frame(width: 100, height: 100)
                            .scaleEffect(isScaled ? 1.5 : 1.0)
                            .animation(.easeInOut(duration: 1.0), value: isScaled)
                    } else {
                        Button(action: startCountdown) {
                            Text("Başla")
                                .font(.title)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .frame(width: geometry.size.width / 2, height: geometry.size.height)
            Spacer()
        }
    }

    private func portraitLayout(geometry: GeometryProxy) -> some View {
        VStack {
            Text("Anlık Hız")
                .font(.title)
                .padding()
            let speedText = getSpeedText()
            Text(speedText)
                .font(.title2)
                .padding()
            if countdownFinished {
                Text("\(String(format: "%.2f", elapsedTime)) sn")
                    .font(.title3)
                    .padding()
            } else {
                if countdownStarted {
                    Text("\(secondsRemaining)")
                        .font(.title)
                        .padding()
                        .frame(width: 100, height: 100)
                        .scaleEffect(isScaled ? 1.5 : 1.0)
                        .animation(.easeInOut(duration: 1.0), value: isScaled)
                } else {
                    Button(action: startCountdown) {
                        Text("Başla")
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .frame(width: geometry.size.width, height: geometry.size.height)
    }

    private var timerPublisher: Timer.TimerPublisher {
        Timer.publish(every: 0.01, on: .main, in: .common)
    }

    private func startCountdown() {
        secondsRemaining = 5
        elapsedTime = 0
        countdownFinished = false
        countdownStarted = true
        startTime = nil
        
        // Hide button and start countdown timer
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.secondsRemaining > 0 {
                self.secondsRemaining -= 1
            } else {
                self.countdownFinished = true
                self.startTime = Date() // Start timing after countdown finishes
                timer.invalidate()
            }
        }
    }
    
    private func startTimer() {
        // Start the timer for elapsed time calculation
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if countdownFinished {
                elapsedTime = Date().timeIntervalSince(startTime ?? Date())
            }
        }
    }
    
    private func getSpeedText() -> String {
        let speedInKph = locationManager1.speed
        let speedInMph = speedInKph * 0.621371
        
        if speedUnitIndex == 0 {
            // Check if speed exceeds 100 km/h and stop timing
            if speedInKph >= 100 {
                elapsedTime = Date().timeIntervalSince(startTime ?? Date())
                return String(format: "%.f km/h", speedInKph)
            }
            return String(format: "%.f km/h", speedInKph)
        } else {
            // Check if speed exceeds 65 mph and stop timing
            if speedInMph >= 65 {
                elapsedTime = Date().timeIntervalSince(startTime ?? Date())
                return String(format: "%.f mph", speedInMph)
            }
            return String(format: "%.f mph", speedInMph)
        }
    }
}


#Preview {
    SpeedView(showSpeed: .constant(true))
}

enum SpeedUnit: String, CaseIterable {
    case kmh = "km/h"
    case mph = "mph"
    
    var symbol: String {
        return self.rawValue
    }
}
