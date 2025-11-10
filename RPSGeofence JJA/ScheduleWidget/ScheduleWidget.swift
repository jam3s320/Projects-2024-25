//
//  ScheduleWidget.swift
//  ScheduleWidget
//
//  Created by Hansini Velichety on 2/18/24.
//
/*
import WidgetKit
import SwiftUI

@main
struct ScheduleWidgetBundle: WidgetBundle
{
   @WidgetBundleBuilder
    var body: some Widget
    {
        //ScheduleWidget()
        NextEventWidget()
        CalendarWidget()
        
    }
}

struct CalendarProvider: TimelineProvider
{
    func placeholder(in context: Context) -> ClassEntry
    {
        let currentDay = DayFunctions().getDay(date: Date())
        let currentEvents = DayFunctions().getRemainingEvents(today: currentDay, date: Date())
        return ClassEntry(date: Date(), day: currentDay, events: currentEvents)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ClassEntry) -> ()) {
       
        let currentDay = DayFunctions().getDay(date: Date())
        let currentEvents = DayFunctions().getRemainingEvents(today: currentDay, date: Date())
        let entry = ClassEntry(date: Date(), day: currentDay, events: currentEvents)
        completion(entry)
        
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ClassEntry>) -> ())
    {
        var entries: [ClassEntry] = []
        
        let currentDate = Date()
        let currentDay = DayFunctions().getDay(date: currentDate)
        
        let startOfDate = DayFunctions().createDateWithTime(year: Calendar.current.component(.year, from: currentDate), month: DayFunctions().getMonth(date: currentDate), day: DayFunctions().getDayofMonth(date: currentDate), hour: 8, minute: 15)
        for hourOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: startOfDate)!
            let currentEvents = DayFunctions().getRemainingEvents(today: currentDay, date: entryDate)
            let entry = ClassEntry(date: entryDate, day: currentDay, events: currentEvents)
            entries.append(entry)
            
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
}

struct ClassEntry: TimelineEntry
{
    let date: Date
    let day: Day
    let events: [Event]

}

struct CalendarWidgetEntryView : View {
    var entry: ClassEntry
    var body: some View {
        HStack(spacing: 20)
        {
            let currentEvents = DayFunctions().getRemainingEvents(today: entry.day, date: Date())
            
            VStack(spacing: -5)
            {
                Text("Day")
                    .font(.caption2)
                    .foregroundColor(.black.opacity(0.4))
                Text(entry.day.id)
                    .font(.system(size: 72, weight: .heavy))
                    .foregroundColor(Color("maroon").opacity(0.8))
                if currentEvents.isEmpty
                {

                }
                else
                {
                    ClassView(event: currentEvents[0])
                        .padding(.leading, 5)
                }
                
            }
            
            VStack(spacing: 8)
            {
                if currentEvents.isEmpty
                {
                    Text("Nothing Scheduled")
                        .padding(.leading, 20)
                        .foregroundColor(.black)
                }
                else
                {
                    ForEach(Array(currentEvents.enumerated()), id: \.element) { index, item in
                        if index >= 1 && index <= 3{
                            ClassView(event: item)
                        }
                        
                    }
                }
            }
            
        }
        .containerBackground(for: .widget) {
        ContainerRelativeShape()
            .fill(Color.white.gradient)
            
        }
    }
}

struct CalendarWidget: Widget
{
    let kind: String = "CalendarWidget"

    var body: some WidgetConfiguration
    {
        StaticConfiguration(kind: kind, provider: CalendarProvider()) { entry in
            CalendarWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Schedule")
        .description("Displays your class schedule.")
        .supportedFamilies([.systemMedium])
    }
}

struct NextEventProvider: TimelineProvider
{
    func placeholder(in context: Context) -> NextEventEntry
    {
        let currentDay = DayFunctions().getDay(date: Date())
        let currentEvents = DayFunctions().getRemainingEvents(today: currentDay, date: Date())
        return NextEventEntry(date: Date(), day: currentDay, events: currentEvents)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (NextEventEntry) -> ()) {
       
        let currentDay = DayFunctions().getDay(date: Date())
        let currentEvents = DayFunctions().getRemainingEvents(today: currentDay, date: Date())
        let entry = NextEventEntry(date: Date(), day: currentDay, events: currentEvents)
        completion(entry)
        
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<NextEventEntry>) -> ())
    {
        var entries: [NextEventEntry] = []
        
        let currentDate = Date()
        let currentDay = DayFunctions().getDay(date: currentDate)
        let currentEvents = DayFunctions().getRemainingEvents(today: currentDay, date: Date())
        for hourOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let startOfDate = DayFunctions().createDateWithTime(year: Calendar.current.component(.year, from: entryDate), month: DayFunctions().getMonth(date: entryDate), day: DayFunctions().getDayofMonth(date: entryDate), hour: 8, minute: 15)
            let entry = NextEventEntry(date: startOfDate, day: currentDay, events: currentEvents)
            entries.append(entry)
            
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
}

struct NextEventEntry: TimelineEntry
{
    let date: Date
    let day: Day
    let events: [Event]

}

struct NextEventWidgetEntryView : View {
    var entry: NextEventEntry
    var body: some View {
        HStack(spacing: 20)
        {
            let currentEvents = DayFunctions().getRemainingEvents(today: entry.day, date: Date())
            
            VStack(spacing: -5)
            {
                Text("Day")
                    .font(.caption2)
                    .foregroundColor(.black.opacity(0.4))
                Text(entry.day.id)
                    .font(.system(size: 72, weight: .heavy))
                    .foregroundColor(Color("maroon").opacity(0.8))
                if currentEvents.isEmpty
                {
                    Text("Nothing Scheduled")
                        .font(.subheadline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .foregroundColor(.black.opacity(0.8))
                        .padding(.top, 5)
                }
                else
                {
                    NextEventView(event: currentEvents[0])
                        .padding(.leading, 5)
                }
                
            }
            
        }
        .containerBackground(for: .widget) {
        ContainerRelativeShape()
            .fill(Color.white.gradient)
            
        }
    }
}

struct NextEventWidget: Widget
{
    let kind: String = "CalendarWidget"

    var body: some WidgetConfiguration
    {
        StaticConfiguration(kind: kind, provider: NextEventProvider()) { entry in
            NextEventWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Next Class")
        .description("Displays the day and your next class.")
        .supportedFamilies([.systemSmall])
    }
}






struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> DayEntry{
        let currentDay = DayFunctions().getDay(date: Date())
        return DayEntry(date: Date(), day: currentDay)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DayEntry) -> ()) {
       
        let currentDay = DayFunctions().getDay(date: Date())
        
        let entry = DayEntry(date: Date(), day: currentDay)
        completion(entry)
        
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ())
    {
        var entries: [DayEntry] = []
        
        let currentDate = Date()
        let currentDay = DayFunctions().getDay(date: currentDate)
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let startOfDate = Calendar.current.startOfDay(for: entryDate)
            let entry = DayEntry(date: startOfDate, day: currentDay)
            entries.append(entry)
            
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct DayEntry: TimelineEntry 
{
    let date: Date
    let day: Day
}

struct ScheduleWidgetEntryView : View {
    var entry: DayEntry

    var body: some View {
        ZStack{
            
            
            VStack(spacing: 4){
                HStack
                {
                   
                    Text(entry.date.formatted(.dateTime.weekday(.wide)))
                        .font(.title3)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .minimumScaleFactor(0.6)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                VStack(spacing: -11){
                    Text("Day")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    
                    Text(entry.day.id)
                        .font(.system(size: 80, weight: .heavy))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        
        }
        .containerBackground(for: .widget) {
          ContainerRelativeShape()
                .fill(Color("maroon").gradient)
        }
            
    }
}

struct ScheduleWidget: Widget {
    
    let kind: String = "ScheduleWidget"

    var body: some WidgetConfiguration 
    {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ScheduleWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Day")
        .description("Display Day Number")
        .supportedFamilies([.systemSmall])
    }
   
}


*/


