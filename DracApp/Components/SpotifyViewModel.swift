//
//  ContentView.swift
//  DracApp
//
//  Created by Feyzullah Durası on 12.08.2024.
//

import SwiftUI
import Combine
import SpotifyiOS

class SpotifyViewModel: NSObject, ObservableObject, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate, SPTSessionManagerDelegate {
    @Published var accessToken: String?
    @Published var isConnected: Bool = false
    @Published var trackName: String = ""
    @Published var isPaused: Bool = true
    @Published var trackImage: UIImage?

    private var appRemote: SPTAppRemote?
    private var sessionManager: SPTSessionManager?
    private var lastPlayerState: SPTAppRemotePlayerState?
    
    private let spotifyClientId = "your-client-id"
    private let redirectUri = URL(string: "your-redirect-uri")!
    private let spotifyClientSecretKey = "your-client-secret-key"
    private let scope = "user-read-playback-state user-modify-playback-state"
    private let tokenSwapURL = URL(string: "http://localhost:1234/swap")!
    private let tokenRefreshURL = URL(string: "http://localhost:1234/refresh")!

    override init() {
        super.init()
        setupSpotify()
    }

    private func setupSpotify() {
        let configuration = SPTConfiguration(clientID: spotifyClientId, redirectURL: redirectUri)
        configuration.tokenSwapURL = tokenSwapURL
        configuration.tokenRefreshURL = tokenRefreshURL
        appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote?.delegate = self

        sessionManager = SPTSessionManager(configuration: configuration, delegate: self)
    }

    func connect() {
        guard let sessionManager = sessionManager else { return }
        sessionManager.initiateSession(with: scopes, options: .clientOnly, campaign: nil)
    }

    func update(playerState: SPTAppRemotePlayerState) {
        if lastPlayerState?.track.uri != playerState.track.uri {
            fetchArtwork(for: playerState.track)
        }
        lastPlayerState = playerState
        trackName = playerState.track.name
        isPaused = playerState.isPaused
    }

    func didTapPauseOrPlay() {
        if let lastPlayerState = lastPlayerState, lastPlayerState.isPaused {
            appRemote?.playerAPI?.resume(nil)
        } else {
            appRemote?.playerAPI?.pause(nil)
        }
    }

    func didTapPreviousTrack() {
        appRemote?.playerAPI?.skip(toPrevious: nil)
    }
    
    func didTapNextTrack() {
        appRemote?.playerAPI?.skip(toNext: nil)
    }

    func fetchAccessToken(completion: @escaping ([String: Any]?, Error?) -> Void) {
        let url = URL(string: "https://accounts.spotify.com/api/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let spotifyAuthKey = "Basic \((spotifyClientId + ":" + spotifyClientSecretKey).data(using: .utf8)!.base64EncodedString())"
        request.allHTTPHeaderFields = ["Authorization": spotifyAuthKey,
                                       "Content-Type": "application/x-www-form-urlencoded"]

        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [
            URLQueryItem(name: "client_id", value: spotifyClientId),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            //URLQueryItem(name: "code", value: responseCode!),
            URLQueryItem(name: "redirect_uri", value: redirectUri.absoluteString),
            URLQueryItem(name: "scope", value: scope)
        ]

        request.httpBody = requestBodyComponents.query?.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, (response as? HTTPURLResponse)?.statusCode == 200, error == nil else {
                print("Error fetching token \(error?.localizedDescription ?? "")")
                return completion(nil, error)
            }
            let responseObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            print("Access Token Dictionary=", responseObject ?? "")
            completion(responseObject, nil)
        }
        task.resume()
    }

    func fetchArtwork(for track: SPTAppRemoteTrack) {
        appRemote?.imageAPI?.fetchImage(forItem: track, with: CGSize.zero) { [weak self] (image, error) in
            if let image = image as? UIImage {
                DispatchQueue.main.async {
                    self?.trackImage = image
                }
            } else if let error = error {
                print("Error fetching track image: " + error.localizedDescription)
            }
        }
    }

    func fetchPlayerState() {
        appRemote?.playerAPI?.getPlayerState { [weak self] (playerState, error) in
            if let playerState = playerState as? SPTAppRemotePlayerState {
                self?.update(playerState: playerState)
            } else if let error = error {
                print("Error getting player state:" + error.localizedDescription)
            }
        }
    }

    // MARK: - SPTAppRemoteDelegate
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        isConnected = true
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
            if let error = error {
                print("Error subscribing to player state:" + error.localizedDescription)
            }
        })
        fetchPlayerState()
    }

    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        isConnected = false
        lastPlayerState = nil
    }

    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        isConnected = false
        lastPlayerState = nil
    }

    // MARK: - SPTAppRemotePlayerStateDelegate
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        update(playerState: playerState)
    }

    // MARK: - SPTSessionManagerDelegate
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        if error.localizedDescription == "The operation couldn’t be completed. (com.spotify.sdk.login error 1.)" {
            print("AUTHENTICATE with WEBAPI")
        } else {
            // Handle error
        }
    }

    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        // Handle session renewal
    }

    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        appRemote?.connectionParameters.accessToken = session.accessToken
        appRemote?.connect()
    }
}
