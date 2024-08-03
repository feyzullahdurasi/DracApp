import SwiftUI
import MapKit

struct MainView: View {
    @State private var activeView: ActiveView?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.0082, longitude: 28.9784),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if geometry.size.width > geometry.size.height {
                    landscapeLayout(geometry: geometry)
                } else {
                    portraitLayout(geometry: geometry)
                }
            }
        }
        .ignoresSafeArea()
    }
    
    private func portraitLayout(geometry: GeometryProxy) -> some View {
        VStack(spacing: 10) {
            Spacer()
            activeViewContent(geometry: geometry)
            buttonBar
        }
    }
    
    private func landscapeLayout(geometry: GeometryProxy) -> some View {
        HStack {
            Spacer()
            activeViewContent(geometry: geometry)
            buttonColumn
        }
    }
    
    private func activeViewContent(geometry: GeometryProxy) -> some View {
        Group {
            if let activeView = activeView {
                viewForActiveView(activeView, geometry: geometry)
            }
        }
    }
    
    private func viewForActiveView(_ view: ActiveView, geometry: GeometryProxy) -> some View {
        let frameSize = frameSize(for: geometry)
        return Group {
            switch view {
            case .maps:
                MapView(region: $region)
            case .contacts:
                ContactsView(showContacts: .constant(true))
            case .youtube:
                YouTubeView(showYouTube: .constant(true))
            case .instagram:
                InstagramView(showInstagram: .constant(true))
            }
        }
        .frame(width: frameSize.width, height: frameSize.height)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
    
    private func frameSize(for geometry: GeometryProxy) -> CGSize {
        let isLandscape = geometry.size.width > geometry.size.height
        let width = isLandscape ? geometry.size.width - 180 : geometry.size.width - 40
        let height = isLandscape ? geometry.size.height - 40 : geometry.size.height - 200
        return CGSize(width: width, height: height)
    }
    
    private var buttonBar: some View {
        HStack(spacing: 20) {
            Spacer()
            ForEach(ActiveView.allCases, id: \.self) { view in
                buttonView(for: view)
            }
            Spacer()
        }
        .padding(.vertical)
        .background(Color.gray)
    }
    
    private var buttonColumn: some View {
        VStack(alignment: .trailing, spacing: 20) {
            Spacer()
            ForEach(ActiveView.allCases, id: \.self) { view in
                buttonView(for: view)
            }
            Spacer()
        }
        .padding(.horizontal)
        .background(Color.gray)
    }
    
    private func buttonView(for view: ActiveView) -> some View {
        Button(action: { activeView = (activeView == view) ? nil : view }) {
            Image(systemName: view.systemImageName)
                .font(.system(size: 30))
                .padding()
                .background(view.backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

enum ActiveView: CaseIterable {
    case maps, contacts, youtube, instagram
    
    var systemImageName: String {
        switch self {
        case .maps: return "map"
        case .contacts: return "phone"
        case .youtube: return "music.note"
        case .instagram: return "car.fill"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .maps: return .blue
        case .contacts: return .green
        case .youtube: return .purple
        case .instagram: return .orange
        }
    }
}

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

struct YouTubeView: View {
    @Binding var showYouTube: Bool
    
    var body: some View {
        GenericView(isShowing: $showYouTube, title: "YouTube View")
    }
}

struct InstagramView: View {
    @Binding var showInstagram: Bool
    
    var body: some View {
        GenericView(isShowing: $showInstagram, title: "Instagram View")
    }
}

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
    }
}

#Preview {
    MainView()
}
