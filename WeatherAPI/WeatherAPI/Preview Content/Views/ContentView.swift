//
//  ContentView.swift
//  WeatherAPI
//
//  Created by James Mallari on 2/21/25.
//

import SwiftUI
import CoreLocation

struct Coordinates: Equatable {
    let latitude: Double
    let longitude: Double
}

struct ContentView: View {
    @State private var weatherData: WeatherData? = nil
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var searchText = ""
    @StateObject private var locationManager = LocationManager()

    let apiKey = "f0dc44c08219416ebf7184644252801" // Replace with your API key

    // Load cities from the plist file
    let commonCities: [String] = {
        guard let path = Bundle.main.path(forResource: "Cities", ofType: "plist"),
              let cities = NSArray(contentsOfFile: path) as? [String] else {
            return [] // Return an empty array if the plist file cannot be loaded
        }
        return cities
    }()

    var body: some View {
        VStack {
            // Search Bar
            HStack {
                TextField("Enter a city", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    fetchWeatherData(for: searchText)
                }) {
                    Text("Search")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }

            // Current Location Button
            Button(action: {
                locationManager.requestLocation()
            }) {
                Text("Use Current Location")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            // Common City Buttons (Updated to blue)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(commonCities, id: \.self) { city in
                        Button(action: {
                            fetchWeatherData(for: city)
                        }) {
                            Text(city)
                                .padding()
                                .background(Color.blue) // Blue buttons
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }

            // Weather Data Display
            if isLoading {
                ProgressView("Loading...")
            } else if let weather = weatherData {
                WeatherView(weather: weather)
            } else if let error = errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else {
                VStack {
                    Image(systemName: "cloud.sun")
                        .font(.system(size: 100))
                        .foregroundColor(.gray)
                        .padding()
                    Text("Enter a city or use your current location")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .padding()
            }
        }
        .padding()
        .onChange(of: locationManager.coordinates) { coordinates in
            if let coordinates = coordinates {
                fetchWeatherData(for: "\(coordinates.latitude),\(coordinates.longitude)")
            }
        }
    }

    func fetchWeatherData(for query: String) {
        isLoading = true
        errorMessage = nil

        guard let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(query)&days=3&aqi=yes") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(WeatherData.self, from: data)
                    self.weatherData = decodedResponse
                } catch {
                    self.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var coordinates: Coordinates? = nil

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization() // Request permission
        locationManager.requestLocation() // Fetch current location
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            coordinates = Coordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
