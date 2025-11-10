//
//  Track.swift
//  ItunesSearch
//
//  Created by James Mallari on 10/9/24.
//

import Foundation

struct Track: Codable, Identifiable
{
    var trackId: Int
    
    var id: Int {trackId} //conform identifiabe using the trackId as the Id
    
    var trackName: String
    
    var collectionsName: String
    
    var artworkUrl30: String
    
    var artworkUrl60: String
    
    var artworkUrl100: String
    
    var previewUrl: String
    
}

