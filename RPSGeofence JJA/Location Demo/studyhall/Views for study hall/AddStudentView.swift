//
//  AddStudentView.swift
//  Location Demo
//
//  Created by James Mallari on 4/13/25.
//


import SwiftUI
import Firebase

struct AddStudentView: View {
    @Binding var isPresented: Bool
    var studyHallName: String
    
    @State private var studentName: String = ""
    @State private var selectedStudyHall: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Student Information")) {
                    TextField("Student Name", text: $studentName)
                }
                
                Section(header: Text("Study Hall")) {
                    TextField("Study Hall", text: $selectedStudyHall)
                        .onAppear {
                            // Initialize with the passed study hall name
                            selectedStudyHall = studyHallName
                        }
                }
                
                Section {
                    Button("Add Student") {
                        addStudent()
                    }
                    .disabled(studentName.isEmpty || selectedStudyHall.isEmpty)
                }
            }
            .navigationTitle("Add Student")
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            })
        }
    }
    
    private func addStudent() {
        
        let studyHallToUse = selectedStudyHall.isEmpty ? studyHallName : selectedStudyHall
        let db = Database.database().reference().child("Services").child("StudyHallServices").child(studyHallToUse).child("ListOfStudents")
        
        db.observeSingleEvent(of: .value) { snapshot in
            var studentsList = [[String: Any]]()
            
            if let existingList = snapshot.value as? [[String: Any]] {
                studentsList = existingList
            }
            
            // Add new student
            let newStudent: [String: Any] = [
                "Name": studentName,
                "Tardy": false,
                "SignOutRequestStatus": "none",
                "IsSignedOut": false
            ]
            
            studentsList.append(newStudent)
            
            // Save updated list
            db.setValue(studentsList) { error, _ in
                if let error = error {
                    print("Error adding student: \(error.localizedDescription)")
                } else {
                    print("Student added successfully")
                    isPresented = false
                }
            }
        }
    }
}
