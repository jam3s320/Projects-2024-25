//
//  Student.swift
//  Geofence_porject1App 2
//
//  Created by 毛智健 on 2/21/24.
//

import Foundation
import FirebaseFirestore

// Sign out status enum
enum SignOutStatus: String, Codable {
    case none = "none"
    case pending = "pending"
    case approved = "approved"
    case denied = "denied"
}

struct Student: Identifiable {
    let id = UUID()
    var name: String
    var isTardy: Bool
    
    // Sign out related properties
    var isSignedOut: Bool = false
    var signOutTime: Date? = nil
    var signOutDestination: String? = nil
    var signOutRequestStatus: SignOutStatus = .none
    var signOutDenialReason: String? = nil
}
