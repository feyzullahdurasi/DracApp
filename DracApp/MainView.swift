import SwiftUI
import MapKit

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
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
            ForEach(Array(viewModel.activeViews), id: \.self) { view in
                viewForActiveView(view, geometry: geometry)
            }
            buttonBar
        }
    }
    
    private func landscapeLayout(geometry: GeometryProxy) -> some View {
        HStack {
            Spacer()
            ForEach(Array(viewModel.activeViews), id: \.self) { view in
                viewForActiveView(view, geometry: geometry)
            }
            buttonColumn
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
        let width = isLandscape ? (geometry.size.width - 180) / CGFloat(viewModel.activeViews.count) : (geometry.size.width - 40)
        let height = isLandscape ? (geometry.size.height - 40) : (geometry.size.height - 200) / CGFloat(viewModel.activeViews.count)
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
}

#Preview {
    MainView()
}
