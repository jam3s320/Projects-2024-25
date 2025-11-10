import SwiftUI
import Combine
import Foundation

class BannerTextManager: ObservableObject {
    
    let objectWillChange = ObservableObjectPublisher()
    
    @Published var bannerText : [BannerText] = [BannerText(id: UUID().uuidString, type: "funFact", text: "Rps is such a great rps great rps school great great. RPS is life. RPS is love. RPS is the best. Submit to RPS. Become RPS. Part of the crew, part of the ship. Part of the crew, part of the ship. Part of the crew, part of the ship. Part of the crew, part of the ship."), BannerText(id: UUID().uuidString, type: "funFact", text: "Rps was founded in a year"), BannerText(id: UUID().uuidString, type: "funFact", text: "RPS has 17 people in the entire school.")]
    
    var marqueeTiming = 0.0
    
    init(){
        getData() { info in
            self.bannerText.append(BannerText(id: UUID().uuidString, type: "sports", text: info))
        }
    }
    
    
    var event = EventCalModel() {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    func calcTimeFromString(size: CGSize){
        let timing = (0.02 * size.width)
        self.marqueeTiming = timing
        //return timing
    }
    
    func textSize(textInput: String, font: UIFont)->CGSize{
        let attributes = [NSAttributedString.Key.font: font]
        
        let size = (textInput as NSString).size(withAttributes: attributes)
        return size
    }
   
    
    func dataToString(eventMod: EventCalModel) -> String{
        
        var scores: String = ""
        
        for item in eventMod.items{
            scores = (item.summary + "(" + item.status + ")" + "  ")
        }
        //print(scores)
        
        self.bannerText.append(BannerText(id: UUID().uuidString, type: "sports", text: scores))
        
            
        
        
        self.objectWillChange.send()
        
        return scores
        
        
    }
    
    func getData(completion: @escaping (String) -> ()) {
        
        // We use DateFormatter to format date in US format and get it for Local Timezone
        // First we create DateMidnight for today
        let myDateFormatter = DateFormatter()
        myDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        myDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        //myDateFormatter.dateFormat = "MM-dd-yyyy"
//        let startMO = myDateFormatter.date(from: Date.FormatString())!

//        let endMO = testDate.endOfMonth()
        var dateCompTemp: DateComponents = DateComponents()
        dateCompTemp.year = 2024
        dateCompTemp.month = 3
        dateCompTemp.day = 8
        let dateTemp : Date = Calendar.current.date(from: dateCompTemp)!
        print(dateTemp)
        
        let myDate = myDateFormatter.string(from: Date())
        //Date()

        let newDate = myDateFormatter.date(from: myDate)
        
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone.local //NSTimeZone(abbreviation: "UTC")! as TimeZone //OR NSTimeZone.localTimeZone()
        let dateAtMidnight = calendar.startOfDay(for: newDate!)
        
        
        
        //For End Date we add 1 day to the dateMidNight
//        let components = NSDateComponents()
//        components.day = 1
//        components.second = -1
        let dateAtEnd = Calendar.current.date(byAdding: .day, value: 1, to: dateAtMidnight)!
        //let dateAtEnd = calendar.date(byAdding: components as DateComponents, to: NSDate() as Date, wrappingComponents: true)
        _ = myDateFormatter.string(from: dateAtEnd)

        // This is the Calendar ID for the Sports calendar that I added to my Google Calendar
        let calendarID = "r0cljevk1nuutn96eiblc7679fqiissq@import.calendar.google.com"
        
        // This is the API Key that I created in Google API
        let apiKey = "AIzaSyCgINRZxsT_CO9R1bOrTM8qjNViRy6MQ90"

        var componets = URLComponents()
        componets.scheme = "https"
        componets.host = "www.googleapis.com"
        componets.path = "/calendar/v3/calendars/\(calendarID)/events"
        componets.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "timeMin", value: myDateFormatter.string(from: dateAtMidnight)),
            URLQueryItem(name: "timeMax", value: myDateFormatter.string(from: dateAtEnd)),
            URLQueryItem(name: "maxResults",value: "10"),
            URLQueryItem(name: "showDelted", value: "false"),
            URLQueryItem(name: "orderBy",value: "startTime"),
            URLQueryItem(name: "singleEvents", value: "true")
        ]
        
        let urlFormat = componets.url

        URLSession.shared.dataTask(with: urlFormat!) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        print(data.debugDescription)
                        let dataString = String(decoding: data, as: UTF8.self)
                        //print(dataString)
                        DispatchQueue.main.async {
                            do {
                                let test = try JSONDecoder().decode(EventCal.self, from: data)
                                self.event = EventCalModel(model: test)
                                print("no error")
                                //print(self.event)
                                completion(self.dataToString(eventMod: self.event))
                                
                            } catch {
                                print("this the      error\(error.localizedDescription)")
                                
                            }
                        }
                        
                    }
                }
            }
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
        }.resume()
    }
}

// MARK: - EventCal
struct EventCal: Codable {
    var items: [Item]
}

// MARK: EventCal convenience initializers and mutators

extension EventCal {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EventCal.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        items: [Item]? = nil
    ) -> EventCal {
        return EventCal(
            items: items ?? self.items
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Item
struct Item: Codable {
    var id, status: String
    var summary, description: String?
    var start: Start?
    var end: End?
}

// MARK: Item convenience initializers and mutators

extension Item {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Item.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        id: String? = nil,
        status: String? = nil,
        summary: String?? = nil,
        start: Start?? = nil
    ) -> Item {
        return Item(
            id: id ?? self.id,
            status: status ?? self.status,
            summary: summary ?? self.summary,
            start: start ?? self.start
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Start
struct Start: Codable {
    var date: String?
    var dateTime: String?
    var timeZone: String?
}

// MARK: Start convenience initializers and mutators

extension Start {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Start.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        date: String?? = nil,
        dateTime: String?? = nil,
        timeZone: String?? = nil
    ) -> Start {
        return Start(
            date: date ?? self.date,
            dateTime: dateTime ?? self.dateTime,
            timeZone: timeZone ?? self.timeZone
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Start
struct End: Codable {
    var date: String?
    var dateTime: String?
    var timeZone: String?
}

// MARK: Start convenience initializers and mutators

extension End {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(End.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        date: String?? = nil,
        dateTime: String?? = nil,
        timeZone: String?? = nil
    ) -> Start {
        return Start(
            date: date ?? self.date,
            dateTime: dateTime ?? self.dateTime,
            timeZone: timeZone ?? self.timeZone
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

struct EventCalModel: Identifiable {
    var items: [Item]
    
    let id: UUID

    struct Item: Codable, Identifiable  {
        let id: String
        let status: String
        let summary: String
        let start: String
        let dateTime: String
        let timeZone: String
        let end: String
        let sort: String
    }
    
    init() {
        self.id = UUID()
        self.items = [Item]()
    }
    
    init(model: EventCal) {
        self.init()
        
        for index in 0..<model.items.count {
            let id = model.items[index].id
            let status = model.items[index].status
            let summary = model.items[index].summary ?? ""
            let start = model.items[index].start?.date ?? ""
            let dateTime = model.items[index].start?.dateTime ?? ""
            let timeZone = model.items[index].start?.timeZone ?? ""
            let end = model.items[index].end?.date ?? ""
            let sort = model.items[index].start?.date ?? model.items[index].start?.dateTime
            if model.items[index].status == "cancelled" {
                
            } else {
                var sorted = ""
                if start == "" {
                    sorted = getOnlyDateMonthYearFromFullDate(currentDateFormate: "yyyy-MM-dd'T'HH:mm:ssZ", conVertFormate: "dd", convertDate: sort!)
                } else if dateTime == "" {
                    sorted = getOnlyDateMonthYearFromFullDate(currentDateFormate: "yyyy-MM-dd", conVertFormate: "dd", convertDate: sort!)
                }
                self.items.append(Item(id: id, status: status, summary: summary, start: start, dateTime: dateTime, timeZone: timeZone, end: end, sort: sorted))
            }
        }
    }
}

func getOnlyDateMonthYearFromFullDate(currentDateFormate: String, conVertFormate: String, convertDate: String ) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = currentDateFormate
    let finalDate = formatter.date(from: convertDate)
    formatter.dateFormat = conVertFormate
    let dateString = formatter.string(from: finalDate!)

    return dateString
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    func startOfNextMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.date(byAdding: .month, value: 1, to: Calendar.current.startOfDay(for: self))!))!
    }
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    func endOfNextMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfNextMonth())!
    }
}
