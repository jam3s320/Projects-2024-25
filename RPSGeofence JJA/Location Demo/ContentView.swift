//
//  ContentView.swift
//  Location Demo
//
//  Created by Guntas Dhanjal 02/11/2024
//

import SwiftUI
import EventKit
import Combine
//import iCalendarParser
//import ICalSwift



struct ContentView: View {
    
    @EnvironmentObject var isInZone: LocationListener
    
    
    
    
    
    //@State var now = Date()
    //@State var score = ""
    // Create GetCal object that gets Calendar data from Google
    //@ObservedObject var manager = GetCal()
    //let timer = Timer.publish(every: 4, on: .current, in: .common).autoconnect()

    
    var body: some View
    {
        VStack
        {
            Rectangle().frame(height:50).foregroundColor(.clear)
            
            //Text("\(isInZone.isInZone ? "Fact" : "No Fact" )")

          
//         if isInZone.isInZone
//            {

            //Text(String(manager.event.items.count))
            //var manager: EventCalModel
            // Create a Marquee View with the Data obtained from Calendar
            //MarqueeView(data: manager.event)
            
                
            //Text(String((vEvents?.events.count)!))
                
//                if let firstEvent = vEvents?.events.first, let firstEventSummary = firstEvent.summary {
//                    Text(firstEventSummary)
//                        .onReceive(timer) { _ in
//                            self.score = (vEvents?.events.randomElement()?.summary) ?? ""
//                        }
//                } else {
//                    // Handle the case where vEvents or vEvents.events is nil
//                    // You might want to provide a default value or handle it accordingly
//                    Text("No Games today!")
//                }
            
//            }else{
//                Text("Sorry! No games for you")
//           }



        }
        VStack
        {
            
            NavigationLink(destination: StudyHallSignInPage()) {
                Text("Go to Study Hall Sign In")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Text("Where in the world is Carmen San Diego? ")
            Text("\(isInZone.isInZone ? "she is at RPS" : "she is NOT at RPS" )")
            Text(isInZone.isInZone.description)
            
            
            
            //            Button(action: {
            //                isInZone.isInZone.toggle()
            //            }) {
            //                Text("\(isInZone.isInZone ? "leave the pyramid" : "enter the pyramid" )")
            //            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(isInZone.isInZone ? Color.green : Color.red)
        .edgesIgnoringSafeArea(.all)
        
    }
    
    
}




