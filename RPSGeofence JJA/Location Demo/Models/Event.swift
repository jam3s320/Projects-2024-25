//
//  Event.swift
//  Schedule
//
//  Created by Hansini Velichety on 2/22/24.
//

import Foundation
import SwiftUI

struct Event: Hashable, Codable, Identifiable{
    var id: String
    var number: String
    var period: String
    var startHour: Int
    var displayStartHour: Int
    var startMinute: Int
    var displayStartMinute: String
    var endHour: Int
    var displayEndHour: Int
    var endMinute: Int
    var displayEndMinute: String
    
}
