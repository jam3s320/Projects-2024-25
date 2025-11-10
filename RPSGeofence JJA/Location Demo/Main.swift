//import SwiftUI
//import FirebaseCore
//import GoogleSignIn
//
//
//
//struct Main: View {
//    @State private var page = "google" // Initialize to "selector" for the selection page
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//
//    
//    var body: some View {
//        VStack {
//            // Display views based on the selection
//            if page == "map" {
//                MapView()
//            } else if page == "lunch" {
//                LunchView()
//            } else if page == "schedule" {
//                //NewsView()
//            } else if page == "studyHall" {
//                StudyHallSignInPage()
//            } else if page == "google" {
//                GoogleSignIn()
//            }else {
//                Text("Please select a page")
//            }
//            
//            Picker("Select View", selection: $page) {
//                Text("Map").tag("map")
//                Text("Lunch").tag("lunch")
//                Text("Study Hall").tag("studyHall")
//                Text("Schedule").tag("schedule")
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            .padding()
//        }
//        .overlay(alignment: .top) {
//            //if(isInZone.isInZone){
//                //BannerView(rootData: "funFact")
//            
//                
//               BannerView(rootData: ["funFact","sports"])
//                    .environmentObject(BannerTextManager())
//                    //.animation(.easeIn)
//                 
//                    
//            //}
//        }
//    }
//}
//
//#Preview {
//    Main()
//}

import SwiftUI

struct Main: View {
    @State private var isSignedIn = true
    @State private var page = "map" // Initialize to "selector" for the selection page

    var body: some View {
        if isSignedIn {
            VStack {
                // Display views based on the selection
                if page == "map" {
                    MapView()
                } else if page == "lunch" {
                    LunchView()
                } else if page == "schedule" {
                    //NewsView()
                } else if page == "studyHall" {
                    StudyHallSignInPage()
                } else {
                    Text("Please select a page")
                }
                
                Picker("Select View", selection: $page) {
                    Text("Map").tag("map")
                    Text("Lunch").tag("lunch")
                    Text("Study Hall").tag("studyHall")
                    Text("Schedule").tag("schedule")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            }
            .overlay(alignment: .top) {
                //if(isInZone.isInZone){
                    //BannerView(rootData: "funFact")
                
                    
                   BannerView(rootData: ["funFact","sports"])
                        .environmentObject(BannerTextManager())
                        //.animation(.easeIn)
                     
                        
                //}
            }
        } else {
            GoogleSignIn(isSignedIn: $isSignedIn)
        }
    }
}






