//
//  WebViewNavigation.swift
//  Browser45
//
//  Created by James Mallari on 3/11/25.
//


import Foundation
import Combine

// MARK: - WebViewNavigation
enum WebViewNavigation {
    case backward, forward, reload
}

// MARK: - WebUrlType
enum WebUrlType {
    case publicUrl, localUrl
}

// MARK: - WebViewModel
class WebViewModel: ObservableObject {
    @Published var showLoader: Bool = false
    @Published var showWebTitle: String = ""
    @Published var currentURL: String? = "https://www.google.com" {
        didSet {
            print("Current URL updated to: \(currentURL ?? "nil")")
        }
    }

    func updateURL(_ urlString: String) {
        let newURL: String
        if urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
            newURL = urlString
        } else {
            newURL = "https://\(urlString)"
        }

        // Only update the URL if it has changed
        if currentURL != newURL {
            currentURL = newURL
        }
    }
}

// MARK: - HomeViewModel
class HomeViewModel: ObservableObject {
    @Published var favorites: [Favorite] = [
        Favorite(name: "Google", icon: "globe", url: "https://www.google.com"),
        Favorite(name: "YouTube", icon: "play.rectangle.fill", url: "https://www.youtube.com")
    ]
    
    @Published var bookmarks: [Bookmark] = [
        Bookmark(title: "Swift Documentation", url: "https://developer.apple.com/swift/"),
        Bookmark(title: "Apple", url: "https://www.apple.com")
    ]
    
    @Published var history: [HistoryEntry] = [
        HistoryEntry(title: "Apple", url: "https://www.apple.com", date: Date()), // Date is now in scope
        HistoryEntry(title: "Google", url: "https://www.google.com", date: Date().addingTimeInterval(-86400)) // 1 day ago
    ]
}