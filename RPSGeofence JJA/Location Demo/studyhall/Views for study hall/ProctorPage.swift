//
//  ProctorPage.swift
//  Geofence_porject1App 2
//
//  Created by 毛智健 on 2/21/24.
//
/*
import Foundation
import SwiftUI

struct ProctorPage: View {
    let proctorName: String
    @State private var studyHalls = [StudyHall]()
    
    var body: some View {
        List(studyHalls, id: \.name) { studyHall in
            Text(studyHall.name)
        }
        .onAppear {
            FirebaseService.fetchStudyHalls(forProctor: proctorName) { halls in
                self.studyHalls = halls
            }
        }
    }
}
*/

/*
import Foundation
import SwiftUI
struct ProctorPage: View {
    let proctorName: String
    @State private var studyHalls = [StudyHall]()
    
    var body: some View {
        List(studyHalls, id: \.name) { studyHall in
            NavigationLink(destination: StudyHallDetailView(studyHallName: studyHall.name)) {
                Text(studyHall.name)
            }
        }
        .onAppear {
            FirebaseService.fetchStudyHalls(forProctor: proctorName) { halls in
                self.studyHalls = halls
            }
        }
    }
}
*/
import Foundation
import SwiftUI

struct ProctorPage: View {
    let proctorName: String
    @State private var studyHalls = [StudyHall]()
    @State private var showingAddStudyHallView = false // Step 1: State for showing the add view

    var body: some View {
        List(studyHalls, id: \.name) { studyHall in
            NavigationLink(destination: StudyHallDetailView(studyHallName: studyHall.name)) {
                Text(studyHall.name)
            }
        }
        .navigationBarTitle("Study Halls", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.showingAddStudyHallView = true // Step 2: Show the add view when button is tapped
        }) {
            Image(systemName: "plus")
        })
        .onAppear {
            loadProctorStudyHalls()
        }
        .sheet(isPresented: $showingAddStudyHallView) { // Presentation of AddStudyHallView
            AddStudyHallView(isPresented: $showingAddStudyHallView)
        }
    }
    
    private func loadProctorStudyHalls() {
        FirebaseService.fetchStudyHalls { allHalls in
            // Filter halls to only show those where this person is the proctor
            var proctorHalls: [StudyHall] = []
            let group = DispatchGroup()
            
            for hallName in allHalls {
                group.enter()
                FirebaseService.fetchStudyHallDetails(studyHallName: hallName) { studyHall in
                    if let studyHall = studyHall, studyHall.proctor == self.proctorName {
                        proctorHalls.append(studyHall)
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                self.studyHalls = proctorHalls
            }
        }
    }
}
