//
//  StudentSignOutView.swift
//  Location Demo
//
//  Created by James Mallari on 4/13/25.
//


import SwiftUI
import Firebase

struct StudentSignOutView: View {
    @Environment(\.presentationMode) var presentationMode
    var student: Student
    var studyHallName: String
    @State private var destination: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Where are you going?", text: $destination)
                
                Button("Request Sign Out") {
                    requestSignOut()
                }
                .disabled(destination.isEmpty)
            }
            .navigationBarTitle("Sign Out Request")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func requestSignOut() {
        FirebaseService.updateStudentSignOutRequest(
            forStudyHall: studyHallName,
            student: student,
            signOutDestination: destination
        ) { success in
            if success {
                // Schedule check for tardy after 5 minutes
                scheduleSignOutCheck()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func scheduleSignOutCheck() {
        // This creates a background task that will check if the student should be marked tardy after 5 minutes
        DispatchQueue.main.asyncAfter(deadline: .now() + 300) { // 300 seconds = 5 minutes
            FirebaseService.checkAndMarkTardyIfNeeded(forStudyHall: studyHallName, studentName: student.name)
        }
    }
}
