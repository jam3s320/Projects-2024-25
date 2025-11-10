//
//  WeatherView.swift
//  WeatherAPI
//
//  Created by James Mallari on 2/24/25.
//


import SwiftUI

// WeatherView
struct WeatherView: View {
    let weather: WeatherData

    var body: some View {
        VStack {
            // Location
            Text("\(weather.location.name), \(weather.location.region)")
                .font(.title)

            // Current Temperature
            HStack {
                Text("\(Int(weather.current.temp_c))°C")
                    .font(.system(size: 70))
                Text("(\(celsiusToFahrenheit(weather.current.temp_c))°F)")
                    .font(.system(size: 30))
                    .foregroundColor(.gray)
            }

            // Weather Icon
            Image(systemName: weather.current.condition.iconNameToSystemName())
                .font(.system(size: 50))

            // Feels Like
            HStack {
                Text("Feels like: \(Int(weather.current.feelslike_c))°C")
                Text("(\(celsiusToFahrenheit(weather.current.feelslike_c))°F)")
                    .foregroundColor(.gray)
            }

            // Humidity and Wind
            Text("Humidity: \(weather.current.humidity)%")
            Text("Wind: \(weather.current.wind_kph) kph")

            // Hourly Forecast
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(weather.forecast.forecastday[0].hour, id: \.time) { hour in
                        VStack {
                            Text(hour.time.extractHour())
                            Image(systemName: hour.condition.iconNameToSystemName())
                            Text("\(Int(hour.temp_c))°C")
                            Text("(\(celsiusToFahrenheit(hour.temp_c))°F)")
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                }
            }

            // Daily Forecast
            ForEach(weather.forecast.forecastday, id: \.date) { day in
                HStack {
                    Text(day.date.extractDayOfWeek())
                    Spacer()
                    Image(systemName: day.day.condition.iconNameToSystemName())
                    Text("\(Int(day.day.maxtemp_c))°/\(Int(day.day.mintemp_c))°C")
                    Text("(\(celsiusToFahrenheit(day.day.maxtemp_c))°/\(celsiusToFahrenheit(day.day.mintemp_c))°F)")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
            }
        }
        .padding()
    }

    // Helper function to convert Celsius to Fahrenheit
    func celsiusToFahrenheit(_ celsius: Double) -> Int {
        return Int((celsius * 9/5) + 32)
    }
}
// String Extensions
extension String {
    func extractHour() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // Match the format of your date string
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "ha" // Format to hour (e.g., "2 PM")
            return dateFormatter.string(from: date)
        }
        return "" // Return an empty string if the conversion fails
    }

    func extractDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Match the format of your date string
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "E" // Format to day of the week (e.g., "Mon")
            return dateFormatter.string(from: date)
        }
        return "" // Return an empty string if the conversion fails
    }
}

