//
//  NetworkMonitor.swift
//  Browser45
//
//  Created by James Mallari on 3/11/25.
//


import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    private init() {
        monitor.start(queue: queue)
    }
    
    public func isConnectedToNetwork(completion: @escaping (Bool) -> Void) {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                completion(true)  // Connected to the network
            } else {
                completion(false) // No network connection
            }
        }
    }
}