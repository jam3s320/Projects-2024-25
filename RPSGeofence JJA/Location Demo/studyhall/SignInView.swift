//
//  SignInView.swift
//  Geofence_porject1App 2
//
//  Created by 毛智健 on 2/21/24.
//

import Foundation
/*
import SwiftUI

struct SignInView: View {
    @State private var name = ""
    @Binding var isSignedIn: Bool
    @Binding var userName: String
    
    var body: some View {
        VStack {
            TextField("Enter your name", text: $name)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Sign In") {
                self.userName = name
                self.isSignedIn = true
            }
            .padding()
        }
        .padding()
    }
}
*/

import SwiftUI

struct SignInView: View {
    @State private var studentName = ""
    @State private var proctorName = ""
    @Binding var isSignedIn: Bool
    @Binding var userName: String
    @State private var isProctorSignedIn = false
    
    var body: some View {
            VStack {
                
//                NavigationView {
//                    NavigationLink(destination: StudyHallSignInPage()) {
//                        Text("Go to Study Hall Sign In")
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                }
                NavigationLink(
                                   destination: StudyHallServiceView(userName: userName),
                                   isActive: $isSignedIn
                               ) {
                                   EmptyView()
                               }
                
                TextField("Enter your name", text: $studentName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Student Sign In") {
                    self.userName = studentName
                    self.isSignedIn = true
                }
                .padding()
                
                TextField("Proctor sign in", text: $proctorName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Proctor Submit") {
                    FirebaseService.fetchStudyHalls { halls in
                        // Filter halls to find ones where this person is a proctor
                        let proctorHalls = halls.filter { hallName in
                            // You'd need to fetch details for each hall and check proctor name
                            // This is inefficient but works with your current setup
                            var isProctor = false
                            FirebaseService.fetchStudyHallDetails(studyHallName: hallName) { studyHall in
                                if let studyHall = studyHall, studyHall.proctor == proctorName {
                                    isProctor = true
                                }
                            }
                            return isProctor
                        }
                        
                        if !proctorHalls.isEmpty {
                            self.userName = proctorName
                            self.isProctorSignedIn = true
                        } else {
                            // Handle error or indicate failure
                        }
                    }
                }
                .padding()
                
                // Navigation link to proctor page, hidden and activated programmatically
                NavigationLink(destination: ProctorPage(proctorName: userName), isActive: $isProctorSignedIn) {
                    EmptyView()
                }
            }
            .padding()
        }
    }


