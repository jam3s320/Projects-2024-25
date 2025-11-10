//
//  StudyHallDetailView.swift
//  Geofence_porject1App 2
//
//  Created by 毛智健 on 2/21/24.
//


//teacher 
import Foundation
import SwiftUI

struct StudyHallDetailView: View {
    var studyHallName: String
    @State private var students = [Student]()
    @State private var showAddStudentSheet = false
    @State private var showingEditStudyHallView = false
    @State private var selectedStudent: Student? = nil
    @State private var denialReason: String = ""
    @State private var showingDenialReasonPrompt = false
    
    var body: some View {
        studentListView
            .navigationTitle(studyHallName)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Add Student") {
                        showAddStudentSheet = true
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEditStudyHallView = true
                    }
                }
            }
            .onAppear {
                loadStudents()
            }
            .sheet(isPresented: $showAddStudentSheet) {
                AddStudentView(isPresented: $showAddStudentSheet, studyHallName: studyHallName)
            }
            .sheet(isPresented: $showingEditStudyHallView) {
                EditStudyHallView(isPresented: $showingEditStudyHallView, studyHallName: studyHallName)
            }
            .alert("Denial Reason", isPresented: $showingDenialReasonPrompt) {
                TextField("Reason", text: $denialReason)
                Button("Cancel", role: .cancel) {
                    denialReason = ""
                }
                Button("Deny Sign Out") {
                    if let student = selectedStudent {
                        denySignOut(student: student, reason: denialReason)
                        denialReason = ""
                    }
                }
            } message: {
                Text("Please provide a reason for denying the sign out request")
            }
    }
    
    // Extracted student list view
    private var studentListView: some View {
        List {
            ForEach(students, id: \.id) { student in
                studentRowView(for: student)
            }
        }
    }
    
    // Extracted individual student row
    private func studentRowView(for student: Student) -> some View {
        VStack(alignment: .leading) {
            HStack {
                studentToggle(for: student)
                Text(student.name)
                Spacer()
                studentActionButtons(for: student)
            }
            
            if student.signOutRequestStatus == .pending {
                Text("Requested to go to: \(student.signOutDestination ?? "Unknown")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if student.signOutRequestStatus == .denied, let reason = student.signOutDenialReason {
                Text("Denied: \(reason)")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 4)
    }
    
    // Extracted toggle view
    private func studentToggle(for student: Student) -> some View {
        Toggle("", isOn: createTardyBinding(for: student))
            .labelsHidden()
            .toggleStyle(SwitchToggleStyle(tint: .green))
    }
    
    // Extracted binding creation
    private func createTardyBinding(for student: Student) -> Binding<Bool> {
        return Binding(
            get: { student.isTardy },
            set: { newValue in
                updateStudentTardyStatus(student: student, isTardy: newValue)
            }
        )
    }
    
    
    // Extracted update function
    private func updateStudentTardyStatus(student: Student, isTardy: Bool) {
        if let index = students.firstIndex(where: { $0.id == student.id }) {
            students[index].isTardy = isTardy
            // Local update only until the Firebase service is implemented
            // You can implement this method in your FirebaseService class
            // For now, just update the local state
            print("Would update tardy status to \(isTardy) for student \(student.name) if Firebase method existed")
            
            // TODO: Uncomment when FirebaseService method is implemented
            /*
            FirebaseService.updateStudentTardyStatus(
                forStudyHall: studyHallName,
                student: student,
                isTardy: isTardy
            ) { success in
                print(success ? "Updated successfully" : "Failed to update")
            }
            */
        }
    }
    
    // Extracted student action buttons
    private func studentActionButtons(for student: Student) -> some View {
        Group {
            if student.signOutRequestStatus == .pending {
                HStack {
                    Button(action: {
                        approveSignOut(student: student)
                    }) {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                    }
                    
                    Button(action: {
                        selectedStudent = student
                        showingDenialReasonPrompt = true
                    }) {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.red)
                    }
                }
            } else {
                Text(statusText(for: student))
            }
        }
    }
    
    private func loadStudents() {
        // Use the enhanced fetch method that includes sign out data
        FirebaseService.fetchStudentsWithSignOutData(forStudyHall: studyHallName) { fetchedStudents in
            self.students = fetchedStudents
        }
    }
    
    private func statusText(for student: Student) -> String {
        switch student.signOutRequestStatus {
        case .none:
            return student.isTardy ? "Tardy" : "Present"
        case .pending:
            return "Sign Out Pending"
        case .approved:
            return "Signed Out"
        case .denied:
            return "Sign Out Denied"
        }
    }
    
    private func approveSignOut(student: Student) {
        FirebaseService.approveStudentSignOut(forStudyHall: studyHallName, student: student) { success in
            if success {
                // Refresh the student list to show the updated status
                loadStudents()
            }
        }
    }
    
    private func denySignOut(student: Student, reason: String) {
        FirebaseService.denyStudentSignOut(forStudyHall: studyHallName, student: student, reason: reason) { success in
            if success {
                // Refresh the student list to show the updated status
                loadStudents()
            }
        }
    }
}
