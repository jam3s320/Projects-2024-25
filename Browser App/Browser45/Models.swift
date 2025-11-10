//
//  Models.swift
//  Browser45
//
//  Created by James Mallari on 3/11/25.
//

import Foundation

// MARK: - Data Models
struct Favorite: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let url: String
}

struct Bookmark: Identifiable {
    let id = UUID()
    let title: String
    let url: String
}

struct HistoryEntry: Identifiable {
    let id = UUID()
    let title: String
    let url: String
    let date: Date
}
