//
//  DayView.swift
//  Schedule
//
//  Created by Hansini Velichety on 3/6/24.
//

import SwiftUI

struct DayView: View
{
    var date: Date
    var body: some View
    {
        ZStack(alignment: .leading)
        {
            HStack(spacing: 3.5)
            {
                Text("Day")
                Text(DayFunctions().getDay(date: Date()).id.description)
            }
            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/.opacity(1.5))
            .padding(.leading, 10)
            
            
            
            
            HStack(spacing: 1)
            {
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 3, height: 35)
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 300, height: 35)
            }
            .foregroundColor(.blue.opacity(0.3))
        }
        
        
    }
            
}

#Preview {
    DayView(date: Date())
}
