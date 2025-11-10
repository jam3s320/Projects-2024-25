//
//  WeatherData.swift
//  WeatherAPI
//
//  Created by James Mallari on 2/24/25.
//


import Foundation

struct WeatherData: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast

    struct Location: Codable {
        let name: String
        let region: String
        let country: String
    }

    struct Current: Codable {
        let temp_c: Double
        let condition: Condition
        let feelslike_c: Double
        let humidity: Int
        let wind_kph: Double
    }

    
    struct Condition: Codable {
        let text: String
        let icon: String
    }

    struct Forecast: Codable {
        let forecastday: [ForecastDay]
    }

    struct ForecastDay: Codable {
        let date: String
        let day: Day
        let hour: [Hour]
    }

    struct Day: Codable {
        let maxtemp_c: Double
        let mintemp_c: Double
        let condition: Condition
    }

    struct Hour: Codable {
        let time: String
        let temp_c: Double
        let condition: Condition
    }
}

extension WeatherData.Condition {
    func iconNameToSystemName() -> String {
        let lowercasedText = self.text.lowercased()

        switch lowercasedText {
        case _ where lowercasedText.contains("sunny"):
            return "sun.max"
        case _ where lowercasedText.contains("clear"):
            return "sun.max"
        case _ where lowercasedText.contains("cloudy"):
            return "cloud"
        case _ where lowercasedText.contains("overcast"):
            return "cloud.fill"
        case _ where lowercasedText.contains("rain"):
            return "cloud.rain"
        case _ where lowercasedText.contains("drizzle"):
            return "cloud.drizzle"
        case _ where lowercasedText.contains("thunder"):
            return "cloud.bolt.rain"
        case _ where lowercasedText.contains("snow"):
            return "cloud.snow"
        case _ where lowercasedText.contains("mist") || lowercasedText.contains("fog"):
            return "cloud.fog"
        case _ where lowercasedText.contains("partly cloudy"):
            return "cloud.sun"
        case _ where lowercasedText.contains("wind"):
            return "wind"
        case _ where lowercasedText.contains("haze"):
            return "sun.haze"
        case _ where lowercasedText.contains("storm"):
            return "cloud.bolt"
        case _ where lowercasedText.contains("showers"):
            return "cloud.rain"
        default:
            print("Unknown weather condition: \(self.text)")
            return "questionmark.circle" // Fallback icon
        }
    }
}
