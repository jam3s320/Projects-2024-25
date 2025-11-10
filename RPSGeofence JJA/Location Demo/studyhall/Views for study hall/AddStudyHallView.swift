//
//  AddStudyHallView.swift
//  Geofence_porject1App 2
//
//  Created by 毛智健 on 3/3/24.
//

/*
import Foundation
import SwiftUI

struct AddStudyHallView: View {
    @Binding var isPresented: Bool
    @State private var name: String = ""
    @State private var inGeoFence: Bool = true
    @State private var period: String = ""
    @State private var proctor: String = ""
    @State private var timeFrom: String = ""
    @State private var timeTo: String = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Toggle("In Geo Fence", isOn: $inGeoFence)
                TextField("Period", text: $period)
                TextField("Proctor", text: $proctor)
                TextField("Time From", text: $timeFrom)
                TextField("Time To", text: $timeTo)
                Button("Add") {
                    if let periodInt = Int(period) {
                        FirebaseService.addStudyHall(name: name, inGeoFence: inGeoFence, period: periodInt, proctor: proctor, timeFrom: timeFrom, timeTo: timeTo) { success in
                            if success {
                                print("Study Hall added successfully")
                            } else {
                                print("Failed to add Study Hall")
                            }
                            isPresented = false
                        }
                    }
                }
            }
            .navigationBarTitle("Add Study Hall", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            })
        }
    }
}
*/

import Foundation
import SwiftUI
struct AddStudyHallView: View {
    @Binding var isPresented: Bool
    @State private var name: String = ""
    @State private var GeoFence: Bool = true
    @State private var period: String = ""
    @State private var proctor: String = ""
    @State private var timeFrom: String = ""
    @State private var timeTo: String = ""
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Toggle("In Geo Fence", isOn: $GeoFence)
                TextField("Period", text: $period)
                TextField("Proctor", text: $proctor)
                TextField("Time From", text: $timeFrom)
                TextField("Time To", text: $timeTo)
                Button("Add") {
                    self.showingAlert = true
                }
            }
            .navigationBarTitle("Add Study Hall", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            })
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Confirm"),
                    message: Text("Are you sure you want to add this study hall?"),
                    primaryButton: .destructive(Text("Yes")) {
                        // Handle the confirmation action here
                        if let periodInt = Int(period) {
                            FirebaseService.addStudyHall(
                                name: name,
                                period: period, // Use the string directly, don't convert to Int
                                proctor: proctor,
                                timeFrom: timeFrom,
                                timeTo: timeTo,
                                completion: { success in
                                    if success {
                                        print("Study Hall added successfully")
                                    } else {
                                        print("Failed to add Study Hall")
                                    }
                                    isPresented = false
                                }
                            )
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

