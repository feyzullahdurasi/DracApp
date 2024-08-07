import SwiftUI
import MapKit

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.0082, longitude: 28.9784),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var isFirstLaunch: Bool = !UserDefaults.standard.bool(forKey: "isUserInfoSaved")
    @State private var isWelcomeMessageVisible: Bool = true
    @State private var userName: String = ""
    @State private var isShowingSettings = false
    @State private var isButtonBarVisible: Bool = true
    
    var body: some View {
        ZStack {
            if isFirstLaunch {
                OnboardingView(isFirstLaunch: $isFirstLaunch)
            } else {
                GeometryReader { geometry in
                    ZStack {
                        if geometry.size.width > geometry.size.height {
                            landscapeLayout(geometry: geometry)
                        } else {
                            portraitLayout(geometry: geometry)
                        }
                    }
                    .ignoresSafeArea()
                }
                
                if isWelcomeMessageVisible {
                    WelcomeMessageView(isVisible: $isWelcomeMessageVisible, userName: userName)
                        .onAppear {
                            // Kullanıcı adını UserDefaults'tan al
                            userName = UserDefaults.standard.string(forKey: "userName") ?? ""
                            
                            // 2 saniye boyunca göster
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    isWelcomeMessageVisible = false
                                }
                            }
                        }
                }
            }
        }
        .onAppear {
            if isFirstLaunch {
                UserDefaults.standard.set(false, forKey: "isFirstLaunch")
            }
        }
        .sheet(isPresented: $isShowingSettings) {
            SettingsView(isShowing: $isShowingSettings)
        }
    }
    
    
    private func portraitLayout(geometry: GeometryProxy) -> some View {
        VStack(spacing: 10) {
            Spacer()
            ForEach(Array(viewModel.activeViews), id: \.self) { view in
                viewForActiveView(view, geometry: geometry)
            }
            if isButtonBarVisible {
                buttonBar
            }
        }
    }
    
    private func landscapeLayout(geometry: GeometryProxy) -> some View {
        HStack {
            Spacer()
            ForEach(Array(viewModel.activeViews), id: \.self) { view in
                viewForActiveView(view, geometry: geometry)
            }
            if isButtonBarVisible {
                buttonColumn
            }
        }
    }
    
    private func viewForActiveView(_ view: ActiveView, geometry: GeometryProxy) -> some View {
        let frameSize = frameSize(for: geometry)
        return Group {
            switch view {
            case .maps:
                CustomMapView(region: $region, selectedCoordinate: $selectedCoordinate)
            case .contacts:
                ContactsView(showContacts: .constant(true))
            case .youtube:
                YouTubeView(showYouTube: .constant(true))
            case .instagram:
                InstagramView(showInstagram: .constant(true))
            case .settings:
                SettingsView(isShowing: $isShowingSettings)
            }
        }
        .frame(width: frameSize.width, height: frameSize.height)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
    
    private func frameSize(for geometry: GeometryProxy) -> CGSize {
            let isLandscape = geometry.size.width > geometry.size.height
            let width = isLandscape ? (geometry.size.width - (isButtonBarVisible ? 90 : 0)) / CGFloat(viewModel.activeViews.count) : (geometry.size.width)
            let height = isLandscape ? (geometry.size.height ) : (geometry.size.height - (isButtonBarVisible ? 120 : 0)) / CGFloat(viewModel.activeViews.count)
            return CGSize(width: width, height: height)
        }
    
    private var buttonBar: some View {
        ScrollView (.horizontal){
            HStack(spacing: 20) {
                Spacer()
                ForEach(ActiveView.allCases, id: \.self) { view in
                    buttonView(for: view)
                }
            }
        }
        .padding(.vertical)
        .background(Color.gray)
        .overlay(
            Button(action: toggleButtonBar) {
                Image(systemName: isButtonBarVisible ? "chevron.down" : "chevron.up")
                    .font(.system(size: 15))
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .clipShape(Circle())
            }
                .padding(.bottom ,100)
        )
    }
    
    private var buttonColumn: some View {
        ScrollView {
            VStack(alignment: .trailing, spacing: 20) {
                ForEach(ActiveView.allCases, id: \.self) { view in
                    buttonView(for: view)
                }
            }
        }
        .padding(.horizontal)
        .background(Color.gray)
        .overlay(
            Button(action: toggleButtonBar) {
                Image(systemName: isButtonBarVisible ? "chevron.right" : "chevron.left")
                    .font(.system(size: 20))
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .clipShape(Circle())
            }
                .padding(.trailing, 100)
        )
    }
    
    private func buttonView(for view: ActiveView) -> some View {
        Button(action: {
            viewModel.toggleView(view)
        }) {
            Image(systemName: view.systemImageName)
                .font(.system(size: 30))
                .padding()
                .background(view.backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    private func toggleButtonBar() {
            withAnimation {
                isButtonBarVisible.toggle()
            }
        }
}

struct CustomMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        
        if let coordinate = selectedCoordinate {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            uiView.addAnnotation(annotation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CustomMapView
        
        init(_ parent: CustomMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation else { return }
            
            // Yol tarifi almak için `MKMapItem` oluşturuluyor
            let placemark = MKPlacemark(coordinate: annotation.coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "Destination"
            
            let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            
            // Yol tarifi almak için Maps uygulamasını açma
            mapItem.openInMaps(launchOptions: options)
        }
    }
}


#Preview {
    MainView()
}
