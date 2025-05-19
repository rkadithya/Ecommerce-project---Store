//
//  NetworkMonitor.swift
//  NetworkMonitorKit
//
//  Created by RK Adithya on 19 May 2025
//

import Foundation
import Network
import SwiftUI

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected: Bool = true

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            if path.status == .satisfied {
                self.checkRealInternetConnectivity()
            } else {
                DispatchQueue.main.async {
                    self.isConnected = false
                }
            }
        }
        monitor.start(queue: queue)
    }

    private func checkRealInternetConnectivity() {
        // Try pinging a reliable URL
        guard let url = URL(string: "https://www.google.com/generate_204") else { return }

        var request = URLRequest(url: url)
        request.timeoutInterval = 5

        URLSession.shared.dataTask(with: request) { _, response, _ in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 {
                    self.isConnected = true
                } else {
                    self.isConnected = false
                }
            }
        }.resume()
    }
}
