//
//  MenuService.swift
//  Test
//
//  Created by Larry Liu on 2/22/24.
//


import Foundation

enum MenuCategory: String, CaseIterable {
    case soups = "Soups"
    case salads = "Salads"
    case sidesAndVegetables = "Sides and Vegetables"
    case desserts = "Desserts"
    case entrees = "Entrees"
    case daily = "Daily"
    case deli = "Deli"
    case unknown = "Unknown"

    static func from(_ value: String) -> MenuCategory {
        return self.init(rawValue: value) ?? .unknown
    }
}

enum MenuStation: String, CaseIterable {
    case crossroads = "Crossroads"
    case dailyOffering = "Daily Offering"
    case improvisations = "Improvisations®"
    case mangiaMangia = "Mangia! Mangia!"
    case ps = "P.S."
    case performanceSpotlight = "Performance Spotlight"
    case stockExchange = "Stock Exchange"
    case theClassicCutsDeli = "The Classic Cuts Deli®"
    case unknown = "Unknown"
    
    static func from(_ value: String) -> MenuStation {
        return self.init(rawValue: value) ?? .unknown
    }
    
    static func decode(_ string: String) -> [MenuStation] {
        let components = string.split(separator: ",")
        return components.compactMap { component in
            let trimmedString = component.trimmingCharacters(in: .whitespacesAndNewlines)
            return from(trimmedString)
        }
    }
}

struct MenuItem: Identifiable {
    var id: String
    var name: String
    var category: MenuCategory
    var stations: [MenuStation]
    var allergens: [String]
    
    init(data: MenuDecoder.Item) {
        self.id = data.id
        self.name = data.name
        self.category = MenuCategory.from(data.displayCategory)
        self.stations = MenuStation.decode(data.displayStation)
        self.allergens = data.allergens.allergenNames
    }
}

struct MenuData: Identifiable {
    var id: String
    var items: [MenuItem]
    var categories: LazyDictionary<MenuCategory, [MenuItem]>
    var stations: LazyDictionary<MenuStation, [MenuItem]>
    
    init(id: String, menu: MenuDecoder) {
        var items: [MenuItem] = []
        for obj in menu.specials { items.append(MenuItem(data: obj)) }
        for obj in menu.daily { items.append(MenuItem(data: obj)) }
        for obj in menu.desserts { items.append(MenuItem(data: obj)) }
        for obj in menu.salads { items.append(MenuItem(data: obj)) }
        for obj in menu.sidesAndVegetables { items.append(MenuItem(data: obj)) }
        for obj in menu.soups { items.append(MenuItem(data: obj)) }
        for obj in menu.entrees { items.append(MenuItem(data: obj)) }

        self.id = id
        self.items = items
        self.categories = LazyDictionary(valueFactory: { key in items.filter { $0.category == key } })
        self.stations = LazyDictionary(valueFactory: { key in items.filter { $0.stations.contains(key) } })
    }
}

class MenuService {
    func getData(for date: String, completion: @escaping (Result<MenuData, Error>) -> Void) {
        request(for: date) { result in
            switch result {
            case .success(let data):
                do {
                    let menu = try JSONDecoder().decode(MenuDecoder.self, from: data)
                    let result = MenuData(id: date, menu: menu)
                    completion(.success(result))
                } catch {
                    completion(.failure(NSError(domain: "JSON Error", code: 1, userInfo: ["error": "Unknown decoding error"]))) // Generic error
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func request(for date: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = "https://www.sagedining.com/microsites/getMenuItems?menuId=121489&date=\(date)&meal=Lunch"
        guard let url = URL(string: urlString) else {
            return completion(.failure(NSError(domain: "URL Error", code: 1, userInfo: nil)))
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { return completion(.failure(error)) }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return completion(.failure(NSError(domain: "Network Error", code: 1, userInfo: nil)))
            }
            guard let data = data else {
                return completion(.failure(NSError(domain: "Data Error", code: 1, userInfo: nil)))
            }
            completion(.success(data))
        }

        task.resume()
    }
}

