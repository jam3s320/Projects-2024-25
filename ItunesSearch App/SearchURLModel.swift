//
//  SearchURLModel.swift
//  ItunesSearch
//
//  Created by James Mallari on 10/11/24.
//


import Foundation
 
public class SearchURLModel: ObservableObject
{
    @Published var searchTerm: String
    private let searchBaseURL = "https://itunes.apple.com/search?term="
    
    init(searchTerm: String)
    {
        self.searchTerm = searchTerm  //this.searchTerm
    }
    
     func loadData(completion: @escaping([Track]) -> ())
     {
        let properSearchTerm = searchTerm.replacingOccurrences(of: " ", with: "")
        + "&entity=song"
        
        let urlString = searchBaseURL + properSearchTerm
        
        guard let url = URL(string: urlString) else
        {
            //Bad URL
            print("Invalid URL")
            return
        }
        
        //time to load the data
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request)
        { data, response, error in
            
            
            guard let currentData = data else
            {
                return
            }
            
            
            if let responseDecoder = try?
                JSONDecoder().decode(Response.self, from: currentData)
            {
                DispatchQueue.main.async
                {
                    let results = responseDecoder.results
                    completion(results)
                }
                return
            }
            
        }.resume()
    }
    
}
