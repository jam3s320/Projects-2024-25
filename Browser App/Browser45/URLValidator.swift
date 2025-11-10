//
//  URLValidator.swift
//  Browser45
//
//  Created by James Mallari on 3/11/25.
//


import Foundation

public class URLValidator {
    var urlString = ""
    let baseURLSearch = "https://www.google.com/search?q="
    
    init(urlString: String) {
        self.urlString = urlString
    }
  
    public func validateAndFixURL(urlString: String) -> (Bool, String) {
        let (isValid, validationMessage) = isValidURL(urlString)

        if isValid {
            return (true, urlString.trimmingCharacters(in: .whitespacesAndNewlines))
        } else {
            let (isFixable, fixedURL) = isFixable(urlString)
            if isFixable {
                return (true, fixedURL)
            } else {
                // Search or handle the invalid URL
                return (false, validationMessage)
            }
        }
    }
    
    private func isValidURL(_ urlString: String) -> (Bool, String) {
        if let url = URL(string: urlString.trimmingCharacters(in: .whitespacesAndNewlines)),
           let scheme = url.scheme,
           let host = url.host,
           scheme == "https",
           !host.isEmpty {
            return (true, "Valid URL ✅")
        } else {
            return (false, "Invalid URL ❌")
        }
    }
    
    private func isFixable(_ urlString: String) -> (Bool, String) {
        let periods = urlString.findAllIndexOf(substring: ".")
        guard let lastPeriodIndex = periods.last else {
            return (false, urlString) // No periods, not fixable
        }

        let ending = urlString.subString(lastPeriodIndex + 1, urlString.count)

        if ending == "com" || ending == "edu" || ending == "org" {
            if urlString.hasPrefix("www.") {
                let fixedURL = String(urlString.dropFirst(4)) // Remove "www."
                return (true, fixedURL)
            } else {
                let fixedURL = "www." + urlString // Add "www."
                return (true, fixedURL)
            }
        } else {
            return (false, urlString) // Invalid extension, not fixable
        }
    }
    
    public func fixURL(urlString: String) {
        let tuple = self.isValidURL(urlString)
        if tuple.0 {
            //good
            self.urlString = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            let fixable = self.isFixable(urlString)
            if fixable.0 {
                //fix it
                self.urlString = fixable.1
            } else {
                //search
                var searchTerm = urlString.replacingOccurrences(of: " ", with: "+")
                searchTerm = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
                self.urlString = self.baseURLSearch + searchTerm
            }
        }
    }
}

// MARK: - String Extensions
extension String {
    public func subString(_ from: Int, _ to: Int) -> String {
        if to > from && from >= 0 && from < self.count && to <= self.count {
            let start = self.index(self.startIndex, offsetBy: from)
            let end = self.index(self.startIndex, offsetBy: to)
            return String(self[start..<end])
        }
        return String("")
    }
    
    public func findAllIndexOf(substring: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
            let range = self.range(of: substring, range: searchStartIndex..<self.endIndex) {
            let index = self.distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        return indices
    }
    
    public func firstIndexOf(substring: String) -> Int {
        let indices = self.findAllIndexOf(substring: substring)
        return indices.isEmpty ? -1 : indices[0]
    }
    
    public func lastIndexOf(substring: String) -> Int {
        let indices = self.findAllIndexOf(substring: substring)
        return indices.isEmpty ? -1 : indices[indices.count - 1]
    }
}