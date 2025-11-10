//
//  ClassView.swift
//  Schedule
//
//  Created by Hansini Velichety on 2/22/24.
//

import SwiftUI

struct ClassView: View {
    var event: Event
    
    var body: some View {
        HStack(spacing: 1){
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 3, height: 35)
                .foregroundColor(.gray)
            ZStack(alignment: .leading)
            {
                VStack(alignment: .leading, spacing: -2)
                {
                    Text(event.id)
                        .font(.caption)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.gray)
                    HStack(spacing: 0)
                    {
                        HStack(spacing: 0){
                            Text(event.displayStartHour.description)
                            Text(":")
                            Text(event.displayStartMinute)
                            Text("-")
                            Text(event.displayEndHour.description)
                            Text(":")
                            Text(event.displayEndMinute)
                            
                            
                        }
                        .font(.caption)
                        Text(event.period)
                            .font(.caption2)
                            .padding(.bottom, -1)
                    }
                    .foregroundColor(.gray)
                }
                .padding(5)
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 135, height: 35)
                    .foregroundColor(.gray.opacity(0.2))
            }
            
        }
    }
}

#Preview {
    ClassView(event: Event(id: "1", number: "1", period: "PM", startHour: 21, displayStartHour: 7, startMinute: 30, displayStartMinute: "00", endHour: 22, displayEndHour: 10, endMinute: 30, displayEndMinute: "00"))
}
