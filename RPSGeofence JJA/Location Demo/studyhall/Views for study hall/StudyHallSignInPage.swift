//
//  StudyHallSignInPage.swift
//  Geofence_porject1App 2
//
//  Created by 毛智健 on 3/4/24.
//

import Foundation
import SwiftUI

struct StudyHallSignInPage: View {
    @State private var isSignedIn = false
    @State private var userName = ""

    var body: some View {
        if isSignedIn {
            StudyHallServiceView(userName: userName)
        } else {
            SignInView(isSignedIn: $isSignedIn, userName: $userName)
        }
    }
}
