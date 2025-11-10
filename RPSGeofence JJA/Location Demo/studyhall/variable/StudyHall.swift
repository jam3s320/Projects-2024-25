//
//  StudyHall.swift
//  Geofence_porject1App 2
//
//  Created by 毛智健 on 2/21/24.
//

import Foundation

struct StudyHall {
    let name: String
    var period: Int
    var proctor: String
    var timeFrom: String
    var timeTo: String
    var location: String = ""
    var teacherName: String {
        return proctor
    }
    var startTime: String {
        return timeFrom
    }
    var endTime: String {
        return timeTo
    }
    var isTardy: Bool = false
}
