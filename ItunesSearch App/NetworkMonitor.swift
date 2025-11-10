//
//  NetworkMonitor.swift
//  ItunesSearch
//
//  Created by James Mallari on 10/11/24.
//

import Foundation
import Network


//Reachability

//NEW
public class NetworkMonitor
{
    static let shared = NetworkMonitor() //singleton
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    public init()
    {
        monitor.start(queue: queue)
    }
    
    public func isConnectedToNetwork(completion: @escaping (Bool) -> ())
    {
        monitor.pathUpdateHandler = {path in
            
            if path.status == .satisfied
            {
                //we a connection
                completion(true)
            }
            else
            {
                //no connection
                completion(false)
            }
            
        }
    }
}



