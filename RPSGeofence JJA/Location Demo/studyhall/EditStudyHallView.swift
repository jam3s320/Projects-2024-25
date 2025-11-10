//
//  EditStudyHallView.swift
//  Geofence_porject1App 2
//
//  Created by 毛智健 on 3/3/24.
//

import Foundation
import SwiftUI

struct EditStudyHallView: View {
    @Binding var isPresented: Bool
    var studyHallName: String
    @State private var name: String = ""
    @State private var period: String = ""
    @State private var proctor: String = ""
    @State private var timeFrom: String = ""
    @State private var timeTo: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("StudyHall Details")) {
                    TextField("Name", text: $name)
                    TextField("Period", text: $period)
                    TextField("Proctor", text: $proctor)
                    TextField("Time From", text: $timeFrom)
                    TextField("Time To", text: $timeTo)
                }
                
                Section {
                    Button("Save Changes") {
                        // Call to FirebaseService to update details
                        FirebaseService.updateStudyHall(name: studyHallName, newName: name, period: period, proctor: proctor, timeFrom: timeFrom, timeTo: timeTo) { success in
                            if success {
                                print("StudyHall updated successfully")
                            } else {
                                print("Failed to update StudyHall")
                            }
                            isPresented = false
                        }
                    }
                }
            }
            .navigationBarTitle("Edit StudyHall", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            })
        }
        /*
        .onAppear {
            // Fetch current details and populate fields
            FirebaseService.fetchStudyHallDetails(studyHallName: studyHallName) { details in
                self.name = details.name
                self.period = "\(details.period)"
                self.proctor = details.proctor
                self.timeFrom = details.timeFrom
                self.timeTo = details.timeTo
            }
        }
        */
        .onAppear {
            FirebaseService.fetchStudyHallDetails(studyHallName: studyHallName) { details in
                if let details = details { // Safely unwrapping the optional
                    self.name = details.name
                    self.period = "\(details.period)"
                    self.proctor = details.proctor
                    self.timeFrom = details.timeFrom
                    self.timeTo = details.timeTo
                } else {
                    // Handle the error or empty state appropriately
                    print("Failed to fetch details or details not found")
                }
            }
        }

        
        
    }
}
