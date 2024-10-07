//
//  SpeedometerView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 7.09.2024.
//

import SwiftUI
import UIKit

struct SpeedometerView: View {
    @Binding var showSpeedometer: Bool
    @State private var speed: Double = 0.0 // Speed value
    @State private var rpm: Double = 0.0   // RPM value
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    if geometry.size.width > 400 {
                        // Landscape Layout
                        landscapeLayout(geometry: geometry)
                    } else {
                        portraitLayout(geometry: geometry)
                    }
                }
            }
            .onAppear {
                setOrientation(.landscape)
            }
            .onDisappear {
                setOrientation(.all)
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func landscapeLayout(geometry: GeometryProxy) -> some View {
        
        HStack(spacing: 150) {
            
            GaugeView(value: speed, maxValue: 260, title: "Speed", unit: "km/h")
            GaugeView(value: rpm, maxValue: 7000, title: "RPM", unit: "x1000")
        }
        .padding(.horizontal, 80)
        .onAppear {
            startUpdatingValues()
        }
    }
    private func portraitLayout(geometry: GeometryProxy) -> some View {
        
        HStack(spacing: 150) {
            
            GaugeView(value: speed, maxValue: 260, title: "Speed", unit: "km/h")
        }
        .padding(.horizontal, 80)
        .onAppear {
            startUpdatingValues()
        }
    }
    
    private func startUpdatingValues() {
        // Example function to simulate speed and RPM changes.
        // You can replace it with your own data sources.
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            speed = 230
            rpm = 5840
        }
    }
    
    // Function to change orientation
    private func setOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            delegate.orientationLock = orientation
            UIDevice.current.setValue(orientation == .landscape ? UIInterfaceOrientation.landscapeLeft.rawValue : UIInterfaceOrientation.unknown.rawValue, forKey: "orientation")
        }
    }
}

struct GaugeView: View {
    let value: Double
    let maxValue: Double
    let title: String
    let unit: String
    let colors = [Color(.blue), Color(.red)]
    
    var body: some View {
        VStack(spacing: 50) {
            ZStack {
                Circle()
                    .trim(from: 0.0, to: 0.75)
                    .stroke(Color.black.opacity(0.1), lineWidth: 15)
                    .frame(width: 200, height: 200)
                    .rotationEffect(Angle(degrees: 135))
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(value / maxValue) * 0.75)
                    .stroke(AngularGradient.init(gradient: .init(colors: self.colors), center: .center, angle: .init(degrees: 270)), lineWidth: 15)
                    .frame(width: 200, height: 200)
                    .rotationEffect(Angle(degrees: 135))
                
                NeedleView(angle: Angle(degrees: (value / maxValue) * 270 - 135))
                    .stroke(Color.red, lineWidth: 5)
                    .rotationEffect(Angle(degrees: 270))
                    .animation(.easeInOut(duration: 0.5), value: value)
                
                Text("\(Int(value)) \(unit)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                    .offset(y: 100)
            }
            .frame(width: 200, height: 200)
            Text(title)
                .font(.headline)
        }
    }
}

struct NeedleView: Shape {
    var angle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let needleLength = rect.width * 0.4
        
        let radians = angle.radians
        path.move(to: center)
        path.addLine(to: CGPoint(
            x: center.x + CGFloat(cos(Double(radians)) * needleLength),
            y: center.y + CGFloat(sin(Double(radians)) * needleLength)
        ))
        return path
    }
}

// Function to change orientation
private func setOrientation(_ orientation: UIInterfaceOrientationMask) {
    if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
        delegate.orientationLock = orientation
        UIDevice.current.setValue(orientation == .landscape ? UIInterfaceOrientation.landscapeLeft.rawValue : UIInterfaceOrientation.unknown.rawValue, forKey: "orientation")
    }
}


#Preview {
    SpeedometerView(showSpeedometer: .constant(true))
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    // Orientation lock variable
    var orientationLock = UIInterfaceOrientationMask.all
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: SpeedometerView(showSpeedometer: .constant(true)))
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    // Control the orientation lock
    func windowScene(_ windowScene: UIWindowScene, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }
}
