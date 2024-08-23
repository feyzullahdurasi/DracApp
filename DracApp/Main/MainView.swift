import SwiftUI
import MapKit

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    
    @State private var isFirstLaunch: Bool = !UserDefaults.standard.bool(forKey: "isUserInfoSaved")
    @State private var isWelcomeMessageVisible: Bool = true
    @State private var userName: String = ""
    @State private var isShowingSettings = false
    @State private var isButtonBarVisible: Bool = false
    @State private var isButtonBarVisible1: Bool = false
    @State private var showActionSheet = false
    @State private var selectedStreamingService: StreamingService = .spotify
    @State private var isShowingShopping = false
    @State private var isShowingSleepMode = false

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
        .fullScreenCover(isPresented: $isShowingSettings) {
            SettingsView(isShowing: $isShowingSettings, selectedStreamingService: $selectedStreamingService)
        }
        .fullScreenCover(isPresented: $isShowingShopping){
            ShoppingView(isShowingShop: $isShowingShopping)
        }
        .fullScreenCover(isPresented: $isShowingSleepMode){
            SleepModeView(isShowingSleepMode: $isShowingSleepMode)
        }
    }
    
    
    private func portraitLayout(geometry: GeometryProxy) -> some View {
        VStack {
            
            Spacer()
            ForEach(Array(viewModel.activeViews), id: \.self) { view in
                viewForActiveView(view, geometry: geometry)
            }
            if isButtonBarVisible {
                buttonBar
            } else {
                Button(action: toggleButtonBar) {
                    Image(systemName: "chevron.up" )
                        .font(.system(size: 15))
                        .padding(10)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .clipShape(Circle())
                }
                .ignoresSafeArea(.all)
                .padding(.bottom ,-20)
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
            } else {
                Button(action: toggleButtonBar) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15))
                        .padding(10)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.vertical, 5.0)
    }
    
    private func viewForActiveView(_ view: ActiveView, geometry: GeometryProxy) -> some View {
        let frameSize = frameSize(for: geometry)
        return Group {
            switch view {
            case .maps:
                CustomMapView(region: $locationManager.region, selectedCoordinate: $selectedCoordinate)
            case .contacts:
                ContactsView(showContacts: .constant(true))
            case .music:
                MusicView(selectedStreamingService: selectedStreamingService)
            case .instagram:
                InstagramView(showInstagram: .constant(true))
            case .speed:
                SpeedView(showSpeed: .constant(true))
            }
        }
        .frame(width: frameSize.width, height: frameSize.height)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
    
    private func frameSize(for geometry: GeometryProxy) -> CGSize {
            let isLandscape = geometry.size.width > geometry.size.height
            let width = isLandscape ? (geometry.size.width - (isButtonBarVisible ? 80 : 20)) / CGFloat(viewModel.activeViews.count) : (geometry.size.width)
            let height = isLandscape ? (geometry.size.height ) : (geometry.size.height - (isButtonBarVisible ? 100 : 10)) / CGFloat(viewModel.activeViews.count)
            return CGSize(width: width, height: height)
        }
    
    private var buttonBar: some View {
        ScrollView (.horizontal){
            HStack(spacing: 20) {
                Spacer()
                Button(action: {
                    isShowingSleepMode = true
                }) {
                    Image(systemName: "power")
                        .font(.system(size: 30))
                        .padding()
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                ForEach(ActiveView.allCases, id: \.self) { view in
                    buttonView(for: view)
                }
                Button(action: {
                    isShowingShopping = true
                }) {
                    Image(systemName: "globe")
                        .font(.system(size: 30))
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button(action: {
                    isShowingSettings = true
                }) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 30))
                        .padding()
                        .background(.brown)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding(.vertical)
        .background(Color.gray)
        .overlay(
            Button(action: toggleButtonBar) {
                Image(systemName: "chevron.down")
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
        .padding(.leading)
        .background(Color.gray)
        .overlay(
            Button(action: toggleButtonBar) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20))
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .clipShape(Circle())
            }
                .padding(.trailing, 85)
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

#Preview {
    MainView()
}
