//
//  StudyHallServiceView.swift
//  Geofence_porject1App 2
//
//  Created by 毛智健 on 2/21/24.
//


/*
struct StudyHallServiceView: View {
    let userName: String
    @State private var studyHalls = [String]()
    
    var body: some View {
        List(studyHalls, id: \.self) { studyHall in
            Text(studyHall)
        }
        .onAppear {
            FirebaseService.fetchStudyHalls(forUser: userName) { halls in
                self.studyHalls = halls
            }
        }
    }
}
*/

/*
struct StudyHallServiceView: View {
    let userName: String
    @State private var studyHalls = [String]()
    
    var body: some View {
        List(studyHalls, id: \.self) { studyHall in
            HStack {
                Text(studyHall)
                Spacer()
                Button(action: {
                    markAsNotTardy(studyHall: studyHall)
                }) {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
        .onAppear {
            FirebaseService.fetchStudyHalls(forUser: userName) { halls in
                self.studyHalls = halls
            }
        }
    }
    
    private func markAsNotTardy(studyHall: String) {
        FirebaseService.markStudentAsNotTardy(inStudyHall: studyHall, studentName: userName) { success in
            if success {
                print("Marked as not tardy successfully")
                // Optionally, refresh the list or show a confirmation message
            } else {
                print("Failed to mark as not tardy")
                // Handle errors, e.g., show an alert
            }
        }
    }
}
*/

//students

import Foundation
import SwiftUI

struct StudyHallServiceView: View {
    var userName: String
    @State private var studyHall: StudyHall?
    @State private var student: Student?
    @State private var showingSignOutRequestSheet = false
    @State private var showingNotification = false
    @State private var notificationMessage = ""
    
    var body: some View {
        VStack {
            if let student = student {
                VStack(spacing: 20) {
                    Text("Welcome, \(student.name)")
                        .font(.title)
                    
                    if student.signOutRequestStatus == .none || student.signOutRequestStatus == .denied {
                        Button("Request Sign Out") {
                            showingSignOutRequestSheet = true
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    } else if student.signOutRequestStatus == .pending {
                        Text("Your sign out request is pending approval")
                            .foregroundColor(.orange)
                    } else if student.signOutRequestStatus == .approved {
                        Text("You are signed out")
                            .foregroundColor(.green)
                    }
                    
                    if student.signOutRequestStatus == .denied, let reason = student.signOutDenialReason {
                        Text("Sign out denied: \(reason)")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding()
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            // Find the student with this username
            loadStudentData()
            
            // Check for status changes every few seconds
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                checkForStatusChanges()
            }
        }
        .sheet(isPresented: $showingSignOutRequestSheet) {
            if let student = student, let studyHall = studyHall {
                StudentSignOutView(student: student, studyHallName: studyHall.name)
            }
        }
        .alert(isPresented: $showingNotification) {
            Alert(
                title: Text("Notification"),
                message: Text(notificationMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func loadStudentData() {
        // Find the student by name across all study halls
        FirebaseService.findStudentByName(userName) { foundStudent, studyHallName in
            if let foundStudent = foundStudent, let studyHallName = studyHallName {
                self.student = foundStudent
                
                // Fetch the complete study hall details
                FirebaseService.fetchStudyHallDetails(studyHallName: studyHallName) { fetchedStudyHall in
                    if let fetchedStudyHall = fetchedStudyHall {
                        self.studyHall = fetchedStudyHall
                    }
                }
            }
        }
    }
    
    private func checkForStatusChanges() {
        guard let student = student, let studyHall = studyHall else { return }
        
        FirebaseService.getStudent(forStudyHall: studyHall.name, studentName: student.name) { updatedStudent in
            if let updatedStudent = updatedStudent {
                // Check if the status changed
                if updatedStudent.signOutRequestStatus != self.student?.signOutRequestStatus {
                    // Show notification based on the new status
                    switch updatedStudent.signOutRequestStatus {
                    case .approved:
                        notificationMessage = "Your sign out request has been approved!"
                        showingNotification = true
                    case .denied:
                        notificationMessage = "Your sign out request has been denied: \(updatedStudent.signOutDenialReason ?? "No reason provided")"
                        showingNotification = true
                    default:
                        break
                    }
                }
                
                // Update the local student object
                self.student = updatedStudent
            }
        }
    }
}
