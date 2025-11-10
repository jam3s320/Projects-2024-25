//
//  Day.swift
//  Schedule
//
//  Created by Hansini Velichety on 2/21/24.
//

import Foundation
import SwiftUI

struct Day: Hashable, Codable, Identifiable{
    var id: String
    var order: [String]
    var dates: [Date]
    
}
