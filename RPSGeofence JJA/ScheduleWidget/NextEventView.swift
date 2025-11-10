//
//  NextEventView.swift
//  Schedule
//
//  Created by Hansini Velichety on 2/22/24.
//
/*
import SwiftUI

struct NextEventView: View {
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
                            Text(event.displayStartMinute.description)
                            Text("-")
                            Text(event.displayEndHour.description)
                            Text(":")
                            Text(event.displayEndMinute.description)
                            
                            
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
                    .frame(width: 120, height: 35)
                    .foregroundColor(.gray.opacity(0.2))
            }
            
        }
    }
}

*/
