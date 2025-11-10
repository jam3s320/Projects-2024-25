//
//  ScheduleView.swift
//  Schedule
//
//  Created by Hansini Velichety on 2/29/24.
//

import SwiftUI


struct ScheduleView: View {
    var events: [Event]
    @State private var showingPopover = false
    
    var body: some View {
        
        HStack{
            Button()
            {
                showingPopover = true
            } label:{
               Text("Edit")
            }
                .popover(isPresented: $showingPopover)
                {
                    FormView()
                    
                }
            Spacer()
        }
        .padding(.leading, 45)
        .padding(.trailing, 50)
        Text("Schedule")
            .font(.title)
        
        HStack(spacing: 0)
        {
            Text(Date().formatted(.dateTime.weekday(.wide)))
            Text(",")
            Text(Date().formatted(.dateTime.day().month().year()))
                .padding(.leading, 4)
        }
        DayView(date: Date())
        
        if events.isEmpty == false
        {
            ForEach(events, id: \.self) { event in
                EventView(event: event)
            }
        }
        else if events.isEmpty == true
        {
            Text("Nothing Scheduled")
        }
    
        
        
    }
}


#Preview {
    ScheduleView(events: DayFunctions().createSchedule(day: DayFunctions().getDay(date: Date())))
}
