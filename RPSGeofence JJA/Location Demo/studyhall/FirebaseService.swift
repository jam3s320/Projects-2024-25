//
//  FirebaseService.swift
//  Geofence_porject1App 2
//
//  Created by 毛智健 on 2/21/24.
//

/*
static func fetchStudyHalls(forUser userName: String, completion: @escaping ([String]) -> Void) {
    var userStudyHalls = [String]()
    let db = Database.database().reference().child("Services").child("StudyHallServices")
    
    db.observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
        guard let services = snapshot.value as? [String: [String: Any]] else { return }
        for (key, value) in services {
            if let listOfStudents = value["ListOfStudents"] as? [[String: Any]] {
                for student in listOfStudents {
                    if let name = student["Name"] as? String, name == userName {
                        userStudyHalls.append(key) // Assuming 'key' is the study hall's name
                        break
                    }
                }
            }
        }
        completion(userStudyHalls)
    }) { (error) in
        print(error.localizedDescription)
    }
}
 */

import Foundation
import Firebase

// Define the base FirebaseService struct
struct FirebaseService {
    
}

// MARK: - Study Hall Management Extensions
extension FirebaseService {
    // Fetch all study halls
    static func fetchStudyHalls(completion: @escaping ([String]) -> Void) {
        let db = Database.database().reference().child("Services").child("StudyHallServices")
        
        db.observeSingleEvent(of: .value) { snapshot in
            var studyHallNames = [String]()
            
            guard let studyHalls = snapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            for (key, _) in studyHalls {
                studyHallNames.append(key)
            }
            
            completion(studyHallNames)
        }
    }
    
    // Add a new study hall
    static func addStudyHall(name: String, period: String, proctor: String, timeFrom: String, timeTo: String, completion: @escaping (Bool) -> Void) {
        let db = Database.database().reference().child("Services").child("StudyHallServices").child(name)
        
        // Check if study hall already exists
        db.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                // Study hall already exists
                completion(false)
                return
            }
            
            // Create new study hall data
            let studyHallData: [String: Any] = [
                "Name": name,
                "Period": Int(period) ?? 0,
                "Proctor": proctor,
                "TimeFrom": timeFrom,
                "TimeTo": timeTo,
                "ListOfStudents": [] // Initialize with empty list of students
            ]
            
            // Save to database
            db.setValue(studyHallData) { error, _ in
                completion(error == nil)
            }
        }
    }
    
    // Update existing study hall
    static func updateStudyHall(name: String, newName: String, period: String, proctor: String, timeFrom: String, timeTo: String, completion: @escaping (Bool) -> Void) {
        let db = Database.database().reference().child("Services").child("StudyHallServices").child(name)
        
        let studyHallData: [String: Any] = [
            "Name": newName,
            "Period": Int(period) ?? 0,
            "Proctor": proctor,
            "TimeFrom": timeFrom,
            "TimeTo": timeTo
        ]
        
        db.updateChildValues(studyHallData) { error, _ in
            // If name changed, we need to rename the node
            if name != newName {
                let oldRef = Database.database().reference().child("Services").child("StudyHallServices").child(name)
                let newRef = Database.database().reference().child("Services").child("StudyHallServices").child(newName)
                
                oldRef.observeSingleEvent(of: .value) { snapshot in
                    if let value = snapshot.value {
                        newRef.setValue(value) { error, _ in
                            if error == nil {
                                oldRef.removeValue { error, _ in
                                    completion(error == nil)
                                }
                            } else {
                                completion(false)
                            }
                        }
                    } else {
                        completion(error == nil)
                    }
                }
            } else {
                completion(error == nil)
            }
        }
    }
    
    // Fetch details for a specific study hall
    static func fetchStudyHallDetails(studyHallName: String, completion: @escaping (StudyHall?) -> Void) {
        let db = Database.database().reference().child("Services").child("StudyHallServices").child(studyHallName)
        
        db.observeSingleEvent(of: .value) { snapshot in
            guard let studyHallData = snapshot.value as? [String: Any],
                  let name = studyHallData["Name"] as? String else {
                completion(nil)
                return
            }
            
            let period = studyHallData["Period"] as? Int ?? 0
            let proctor = studyHallData["Proctor"] as? String ?? ""
            let timeFrom = studyHallData["TimeFrom"] as? String ?? ""
            let timeTo = studyHallData["TimeTo"] as? String ?? ""
            let location = studyHallData["Location"] as? String ?? ""
            
            let studyHall = StudyHall(
                name: name,
                period: period,
                proctor: proctor,
                timeFrom: timeFrom,
                timeTo: timeTo,
                location: location
            )
            
            completion(studyHall)
        }
    }
}

// MARK: - Sign Out and Approval Extensions
extension FirebaseService {
    // Update student with sign out request
    static func updateStudentSignOutRequest(forStudyHall studyHall: String, student: Student, signOutDestination: String, completion: @escaping (Bool) -> Void) {
        let db = Database.database().reference().child("Services").child("StudyHallServices").child(studyHall).child("ListOfStudents")
        
        db.observeSingleEvent(of: .value, with: { snapshot in
            if var studentsList = snapshot.value as? [[String: Any]] {
                if let index = studentsList.firstIndex(where: { $0["Name"] as? String == student.name }) {
                    // Update the student's sign out request
                    studentsList[index]["SignOutRequestStatus"] = "pending"
                    studentsList[index]["SignOutDestination"] = signOutDestination
                    studentsList[index]["SignOutTime"] = ServerValue.timestamp()
                    
                    // Write the updated students list back to the database
                    db.setValue(studentsList, withCompletionBlock: { error, _ in
                        completion(error == nil)
                    })
                }
            }
        })
    }
    
    // Approve student sign out request
    static func approveStudentSignOut(forStudyHall studyHall: String, student: Student, completion: @escaping (Bool) -> Void) {
        let db = Database.database().reference().child("Services").child("StudyHallServices").child(studyHall).child("ListOfStudents")
        
        db.observeSingleEvent(of: .value, with: { snapshot in
            if var studentsList = snapshot.value as? [[String: Any]] {
                if let index = studentsList.firstIndex(where: { $0["Name"] as? String == student.name }) {
                    // Update the student's sign out status
                    studentsList[index]["SignOutRequestStatus"] = "approved"
                    studentsList[index]["IsSignedOut"] = true
                    
                    // Write the updated students list back to the database
                    db.setValue(studentsList, withCompletionBlock: { error, _ in
                        completion(error == nil)
                    })
                }
            }
        })
    }
    
    // Deny student sign out request
    static func denyStudentSignOut(forStudyHall studyHall: String, student: Student, reason: String, completion: @escaping (Bool) -> Void) {
        let db = Database.database().reference().child("Services").child("StudyHallServices").child(studyHall).child("ListOfStudents")
        
        db.observeSingleEvent(of: .value, with: { snapshot in
            if var studentsList = snapshot.value as? [[String: Any]] {
                if let index = studentsList.firstIndex(where: { $0["Name"] as? String == student.name }) {
                    // Update the student's sign out status
                    studentsList[index]["SignOutRequestStatus"] = "denied"
                    studentsList[index]["SignOutDenialReason"] = reason
                    
                    // Write the updated students list back to the database
                    db.setValue(studentsList, withCompletionBlock: { error, _ in
                        completion(error == nil)
                    })
                }
            }
        })
    }
    
    // Check if student should be marked tardy (after 5 minutes of pending)
    static func checkAndMarkTardyIfNeeded(forStudyHall studyHall: String, studentName: String) {
        let db = Database.database().reference().child("Services").child("StudyHallServices").child(studyHall).child("ListOfStudents")
        
        db.observeSingleEvent(of: .value, with: { snapshot in
            if var studentsList = snapshot.value as? [[String: Any]] {
                if let index = studentsList.firstIndex(where: { $0["Name"] as? String == studentName }) {
                    let student = studentsList[index]
                    
                    // Check if the request is still pending
                    if let requestStatus = student["SignOutRequestStatus"] as? String,
                       requestStatus == "pending",
                       let signOutTimeValue = student["SignOutTime"] as? Double {
                        
                        let signOutDate = Date(timeIntervalSince1970: signOutTimeValue / 1000) // Convert milliseconds to seconds
                        let currentDate = Date()
                        
                        // Check if 5 minutes (300 seconds) have passed
                        if currentDate.timeIntervalSince(signOutDate) >= 300 {
                            // Mark student as tardy
                            studentsList[index]["Tardy"] = true
                            
                            // Write the updated students list back to the database
                            db.setValue(studentsList, withCompletionBlock: { error, _ in
                                if let error = error {
                                    print("Error marking student as tardy: \(error.localizedDescription)")
                                } else {
                                    print("Student marked as tardy after 5 minutes with no response")
                                }
                            })
                        }
                    }
                }
            }
        })
    }
    
    // Find student by name across all study halls
    static func findStudentByName(_ name: String, completion: @escaping (Student?, String?) -> Void) {
        let db = Database.database().reference().child("Services").child("StudyHallServices")
        
        db.observeSingleEvent(of: .value, with: { snapshot in
            guard let services = snapshot.value as? [String: [String: Any]] else {
                completion(nil, nil)
                return
            }
            
            // Search in each study hall
            for (studyHallName, studyHallData) in services {
                if let studentsList = studyHallData["ListOfStudents"] as? [[String: Any]] {
                    for studentData in studentsList {
                        if let studentName = studentData["Name"] as? String, studentName == name {
                            // Create enhanced student with sign out data
                            var student = Student(name: name, isTardy: studentData["Tardy"] as? Bool ?? false)
                            
                            // Add sign out related properties if they exist
                            if let signOutStatus = studentData["SignOutRequestStatus"] as? String {
                                student.signOutRequestStatus = SignOutStatus(rawValue: signOutStatus) ?? .none
                            }
                            
                            student.signOutDestination = studentData["SignOutDestination"] as? String
                            student.signOutDenialReason = studentData["SignOutDenialReason"] as? String
                            student.isSignedOut = studentData["IsSignedOut"] as? Bool ?? false
                            
                            if let signOutTime = studentData["SignOutTime"] as? Double {
                                student.signOutTime = Date(timeIntervalSince1970: signOutTime / 1000)
                            }
                            
                            completion(student, studyHallName)
                            return
                        }
                    }
                }
            }
            
            // If we get here, student was not found
            completion(nil, nil)
        })
    }
    
    // Get single student from a study hall
    static func getStudent(forStudyHall studyHall: String, studentName: String, completion: @escaping (Student?) -> Void) {
        let db = Database.database().reference().child("Services").child("StudyHallServices").child(studyHall).child("ListOfStudents")
        
        db.observeSingleEvent(of: .value, with: { snapshot in
            if let studentsList = snapshot.value as? [[String: Any]] {
                for studentData in studentsList {
                    if let name = studentData["Name"] as? String, name == studentName {
                        // Create enhanced student with sign out data
                        var student = Student(name: name, isTardy: studentData["Tardy"] as? Bool ?? false)
                        
                        // Add sign out related properties if they exist
                        if let signOutStatus = studentData["SignOutRequestStatus"] as? String {
                            student.signOutRequestStatus = SignOutStatus(rawValue: signOutStatus) ?? .none
                        }
                        
                        student.signOutDestination = studentData["SignOutDestination"] as? String
                        student.signOutDenialReason = studentData["SignOutDenialReason"] as? String
                        student.isSignedOut = studentData["IsSignedOut"] as? Bool ?? false
                        
                        if let signOutTime = studentData["SignOutTime"] as? Double {
                            student.signOutTime = Date(timeIntervalSince1970: signOutTime / 1000)
                        }
                        
                        completion(student)
                        return
                    }
                }
            }
            
            completion(nil)
        })
    }
    
    // Enhanced fetch student method that includes sign out data
    static func fetchStudentsWithSignOutData(forStudyHall studyHall: String, completion: @escaping ([Student]) -> Void) {
        let db = Database.database().reference().child("Services").child("StudyHallServices").child(studyHall).child("ListOfStudents")
        
        db.observeSingleEvent(of: .value, with: { snapshot in
            var students = [Student]()
            if let studentDicts = snapshot.value as? [[String: Any]] {
                for studentDict in studentDicts {
                    if let name = studentDict["Name"] as? String {
                        var student = Student(name: name, isTardy: studentDict["Tardy"] as? Bool ?? false)
                        
                        // Add sign out related properties if they exist
                        if let signOutStatus = studentDict["SignOutRequestStatus"] as? String {
                            student.signOutRequestStatus = SignOutStatus(rawValue: signOutStatus) ?? .none
                        }
                        
                        student.signOutDestination = studentDict["SignOutDestination"] as? String
                        student.signOutDenialReason = studentDict["SignOutDenialReason"] as? String
                        student.isSignedOut = studentDict["IsSignedOut"] as? Bool ?? false
                        
                        if let signOutTime = studentDict["SignOutTime"] as? Double {
                            student.signOutTime = Date(timeIntervalSince1970: signOutTime / 1000)
                        }
                        
                        students.append(student)
                    }
                }
            }
            completion(students)
        })
    }
}
