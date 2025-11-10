
import SwiftUI

public class DayFunctions
{
    func createDate(year: Int, month: Int, day: Int) -> Date
    {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        guard let date = Calendar.current.date(from: components) else { return Date() }
        return date
    }
    
    func createDateWithTime(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date
    {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        guard let date = Calendar.current.date(from: components) else { return Date() }
        return date
    }
    
    func getMonth(date: Date) -> Int
    {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date)
        let month = components.month ?? 0
        return month
    }
    
    func getDayofMonth(date: Date) -> Int
    {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date)
        let day = components.day ?? 0
        return day
    }
    
  
    /*
    func assignNames(period1name: String, period2name: String, period3name: String, period4name: String, period5name: String, period6name: String, period7name: String, period8name: String, period9name: String) -> [String]
    {
        var names: [String] = []
        names.append(period1name)
        names.append(period2name)
        names.append(period3name)
        names.append(period4name)
        names.append(period5name)
        names.append(period6name)
        names.append(period7name)
        names.append(period8name)
        names.append(period9name)
        
        let defaults = UserDefaults.standard
        defaults.set(
            names,
            //forKey: DefaultsKeys.user1
        )
        
        return names
    }
    */
     
    func createSchedule(day: Day) -> [Event]
    {
        var events: [Event] = []
        if day.id == "NA"
        {
            return events
        }
        
        events.append(Event(id: "Period \(day.order[0])", number: day.order[0], period: "AM", startHour: 8, displayStartHour: 8, startMinute: 20, displayStartMinute: "20", endHour: 9, displayEndHour: 9, endMinute: 20, displayEndMinute: "20"))
        events.append(Event(id: "Morning Meeting", number: "Morning Meeting", period: "AM", startHour: 9, displayStartHour: 9, startMinute: 30, displayStartMinute: "30", endHour: 9, displayEndHour: 9, endMinute: 40, displayEndMinute: "40"))
        events.append(Event(id: "Period \(day.order[1])", number: day.order[1], period: "AM", startHour: 9, displayStartHour: 9, startMinute: 50, displayStartMinute: "50", endHour: 10, displayEndHour: 10, endMinute: 50, displayEndMinute: "50"))
        events.append(Event(id: "Period \(day.order[2])", number: day.order[2], period: "PM", startHour: 11, displayStartHour: 11, startMinute: 00, displayStartMinute: "00", endHour: 12, displayEndHour: 12, endMinute: 00, displayEndMinute: "00"))
        events.append(Event(id: "Community Time", number: "Community Time", period: "PM", startHour: 12, displayStartHour: 12, startMinute: 00, displayStartMinute: "00", endHour: 13, displayEndHour: 1, endMinute: 00, displayEndMinute: "00"))
        events.append(Event(id: "Period \(day.order[3])", number: day.order[3], period: "PM", startHour: 13, displayStartHour: 1, startMinute: 10, displayStartMinute: "10", endHour: 14, displayEndHour: 2, endMinute: 10, displayEndMinute: "10"))
        events.append(Event(id: "Period 9", number: "9", period: "PM", startHour: 14, displayStartHour: 2, startMinute: 20, displayStartMinute: "20", endHour: 15, displayEndHour: 3, endMinute: 05, displayEndMinute: "05"))
        /*
        let name1 = names[Int(day.order[0]) ?? 2 - 1]
        let name2 = names[Int(day.order[1]) ?? 2 - 1]
        let name3 = names[Int(day.order[2]) ?? 2 - 1]
        let name4 = names[Int(day.order[3]) ?? 2 - 1]
        let name5 = names[8]
        
        if name1 == ""
        {
            events.append(Event(id: "Period \(day.order[0])", number: day.order[0], period: "AM", startHour: 8, displayStartHour: 8, startMinute: 20, displayStartMinute: "20", endHour: 9, displayEndHour: 9, endMinute: 20, displayEndMinute: "20"))
        }
        else
        {
            events.append(Event(id: name1, number: day.order[0], period: "AM", startHour: 8, displayStartHour: 8, startMinute: 20, displayStartMinute: "20", endHour: 9, displayEndHour: 9, endMinute: 20, displayEndMinute: "20"))
        }
        events.append(Event(id: "Morning Meeting", number: "Morning Meeting", period: "AM", startHour: 9, displayStartHour: 9, startMinute: 30, displayStartMinute: "30", endHour: 9, displayEndHour: 9, endMinute: 40, displayEndMinute: "40"))
        if name2 == ""
        {
            events.append(Event(id: "Period \(day.order[1])", number: day.order[1], period: "AM", startHour: 9, displayStartHour: 9, startMinute: 50, displayStartMinute: "50", endHour: 10, displayEndHour: 10, endMinute: 50, displayEndMinute: "50"))
        }
        else
        {
            events.append(Event(id: name2, number: day.order[1], period: "AM", startHour: 9, displayStartHour: 9, startMinute: 50, displayStartMinute: "50", endHour: 10, displayEndHour: 10, endMinute: 50, displayEndMinute: "50"))
        }
        
        if name3 == ""
        {
            events.append(Event(id: "Period \(day.order[2])", number: day.order[2], period: "PM", startHour: 11, displayStartHour: 11, startMinute: 00, displayStartMinute: "00", endHour: 12, displayEndHour: 12, endMinute: 00, displayEndMinute: "00"))
        }
        else
        {
            events.append(Event(id: name3, number: day.order[2], period: "PM", startHour: 11, displayStartHour: 11, startMinute: 00, displayStartMinute: "00", endHour: 12, displayEndHour: 12, endMinute: 00, displayEndMinute: "00"))
        }
        
        events.append(Event(id: "Community Time", number: "Community Time", period: "PM", startHour: 12, displayStartHour: 12, startMinute: 00, displayStartMinute: "00", endHour: 13, displayEndHour: 1, endMinute: 00, displayEndMinute: "00"))
        
        if name4 == ""
        {
            events.append(Event(id: "Period \(day.order[3])", number: day.order[3], period: "PM", startHour: 13, displayStartHour: 1, startMinute: 10, displayStartMinute: "10", endHour: 14, displayEndHour: 2, endMinute: 10, displayEndMinute: "10"))
        }
        else
        {
            events.append(Event(id: name4, number: day.order[3], period: "PM", startHour: 13, displayStartHour: 1, startMinute: 10, displayStartMinute: "10", endHour: 14, displayEndHour: 2, endMinute: 10, displayEndMinute: "10"))
        }
        
        if name5 == ""
        {
            events.append(Event(id: "Period 9", number: "9", period: "PM", startHour: 14, displayStartHour: 2, startMinute: 20, displayStartMinute: "20", endHour: 15, displayEndHour: 3, endMinute: 05, displayEndMinute: "05"))
        }
        else
        {
            events.append(Event(id: name5, number: "9", period: "PM", startHour: 14, displayStartHour: 2, startMinute: 20, displayStartMinute: "20", endHour: 15, displayEndHour: 3, endMinute: 05, displayEndMinute: "05"))
        }
        
        
        
        
      
        
        
        //testing
        events.append(Event(id: "Period \(day.order[0])", period: "PM", startHour: 24, displayStartHour: 10, startMinute: 20, endHour: 24, displayEndHour: 11, endMinute: 20))
        events.append(Event(id: "Morning Meeting", period: "AM", startHour: 24, displayStartHour: 9, startMinute: 30, endHour: 24, displayEndHour: 9, endMinute: 40))
        events.append(Event(id: "Period \(day.order[1])", period: "PM", startHour: 24, displayStartHour: 11, startMinute: 20, endHour: 0, displayEndHour: 11, endMinute: 20))
        events.append(Event(id: "Period \(day.order[2])", period: "PM", startHour: 24, displayStartHour: 10, startMinute: 20, endHour: 24, displayEndHour: 11, endMinute: 20))
        events.append(Event(id: "Community Time", period: "PM", startHour: 24, displayStartHour: 9, startMinute: 30, endHour: 24, displayEndHour: 9, endMinute: 40))
        events.append(Event(id: "Period \(day.order[3])", period: "PM", startHour: 24, displayStartHour: 10, startMinute: 20, endHour: 24, displayEndHour: 11, endMinute: 20))
         */
        
        return events
    }
    
    func getRemainingEvents(today: Day, date: Date) -> [Event]
    {
        let currentDate = Date()
        let currentHour = Calendar.current.component(.hour, from: currentDate)
        let currentMinute = Calendar.current.component(.minute, from: currentDate)
        var events: [Event] = []
        let schedule = createSchedule(day: today)
        for event in schedule
        {
            if event.startHour > currentHour
            {
                events.append(event)
            }
            else if event.startHour == currentHour && event.startMinute < currentMinute
            {
                events.append(event)
            }
            
        }
        return events
        
    }
    
    func getDay(date: Date) -> Day
    {
        let day1dates = [createDate(year: 2024, month: 3, day: 4), createDate(year: 2024, month: 4, day: 1), createDate(year: 2024, month: 4, day: 15), createDate(year: 2024, month: 4, day: 29), createDate(year: 2024, month: 5, day: 13)]
        let day2dates = [createDate(year: 2024, month: 3, day: 5), createDate(year: 2024, month: 4, day: 2), createDate(year: 2024, month: 4, day: 16), createDate(year: 2024, month: 4, day: 30), createDate(year: 2024, month: 5, day: 14), createDate(year: 2024, month: 5, day: 28)]
        let day3dates = [createDate(year: 2024, month: 2, day: 21), createDate(year: 2024, month: 2, day: 29), createDate(year: 2024, month: 3, day: 6), createDate(year: 2024, month: 3, day: 14), createDate(year: 2024, month: 4, day: 3), createDate(year: 2024, month: 4, day: 11), createDate(year: 2024, month: 4, day: 17), createDate(year: 2024, month: 4, day: 25), createDate(year: 2024, month: 5, day: 1), createDate(year: 2024, month: 5, day: 9), createDate(year: 2024, month: 5, day: 15), createDate(year: 2024, month: 5, day: 23), createDate(year: 2024, month: 5, day: 29)]
        let day4dates = [createDate(year: 2024, month: 2, day: 22), createDate(year: 2024, month: 3, day: 1), createDate(year: 2024, month: 3, day: 7), createDate(year: 2024, month: 3, day: 15), createDate(year: 2024, month: 4, day: 4), createDate(year: 2024, month: 4, day: 12), createDate(year: 2024, month: 4, day: 18), createDate(year: 2024, month: 4, day: 26), createDate(year: 2024, month: 5, day: 2), createDate(year: 2024, month: 5, day: 10), createDate(year: 2024, month: 5, day: 16), createDate(year: 2024, month: 5, day: 24), createDate(year: 2024, month: 5, day: 30)]
        let day5dates = [createDate(year: 2024, month: 2, day: 23), createDate(year: 2024, month: 3, day: 8), createDate(year: 2024, month: 4, day: 5), createDate(year: 2024, month: 4, day: 19), createDate(year: 2024, month: 5, day: 17)]
        let day6dates = [createDate(year: 2024, month: 2, day: 26), createDate(year: 2024, month: 3, day: 11), createDate(year: 2024, month: 4, day: 8), createDate(year: 2024, month: 4, day: 22), createDate(year: 2024, month: 5, day: 6), createDate(year: 2024, month: 5, day: 20)]
        let day7dates = [createDate(year: 2024, month: 2, day: 27), createDate(year: 2024, month: 3, day: 12), createDate(year: 2024, month: 4, day: 9), createDate(year: 2024, month: 4, day: 23), createDate(year: 2024, month: 5, day: 7), createDate(year: 2024, month: 5, day: 21)]
        let day8dates = [createDate(year: 2024, month: 2, day: 28), createDate(year: 2024, month: 3, day: 13), createDate(year: 2024, month: 4, day: 10), createDate(year: 2024, month: 4, day: 24), createDate(year: 2024, month: 5, day: 8), createDate(year: 2024, month: 5, day: 22)]
        
        let fakeDay = Day(id: "0", order: ["1", "3", "5", "7"], dates: [createDate(year: 2024, month: 4, day: 4)])
        
        let day1 = Day(id: "1", order: ["1", "3", "5", "7"], dates: day1dates)
        let day2 = Day(id: "2", order: ["2", "4", "6", "8"], dates: day2dates)
        let day3 = Day(id: "3", order: ["3", "5", "7", "1"], dates: day3dates)
        let day4 = Day(id: "4", order: ["4", "6", "8", "2"], dates: day4dates)
        let day5 = Day(id: "5", order: ["5", "7", "1", "3"], dates: day5dates)
        let day6 = Day(id: "6", order: ["6", "8", "2", "4"], dates: day6dates)
        let day7 = Day(id: "7", order: ["7", "1", "3", "5"], dates: day7dates)
        let day8 = Day(id: "8", order: ["8", "2", "4", "6"], dates: day8dates)
        let defaultday = Day(id: "NA", order: ["", ""], dates: [createDate(year: 0, month: 0, day: 0)])
        let days = [day1, day2, day3, day4, day5, day6, day7, day8, fakeDay]
        
        let currentDate = Date()
        let currentMonth = getMonth(date: currentDate)
        let currentDayofMonth = getDayofMonth(date: currentDate)
        
        for day in days
        {
            for date in day.dates
            {
                let month = getMonth(date: date)
                let dayOfMonth = getDayofMonth(date: date)
                if currentMonth == month && currentDayofMonth == dayOfMonth
                {
                    return day
                }
            }
        }
        return defaultday
    }
        
}
