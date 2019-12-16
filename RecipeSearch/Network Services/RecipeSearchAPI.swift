//
//  RecipeSearchAPI.swift
//  RecipeSearch
//
//  Created by Adam Diaz on 12/15/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct RecipeSearchAPI {
    
    static func fetchRecipe(for searchQuery: String, completion: @escaping (Result<[Recipe], AppError>) -> () ) {
        
        let searchQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "tacos"
        
        // Here we are using string interpolation to build endpoint url
        
        let recipeEndpointURL = "https://api.edamam.com/search?q=\(searchQuery)&app_id=\(SecretKey.appId)&app_key=\(SecretKey.appkey)&from=0&to=50"
        
        // 4. TODO: later we will look at url components and url query items.
        
        guard let url = URL(string: recipeEndpointURL) else {

            completion(.failure(.badURL(recipeEndpointURL)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let searchResults = try JSONDecoder().decode(RecipeSearch.self, from: data)
                   
                    // 1. TODO: use searchResults to create an aray of recipes
                    
                    let recipes = searchResults.hits.map { $0.recipe }
                    
                    // 2. TODO: capture the array of recipes in the completion handler
                    
                    completion(.success(recipes))
                    
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
    }
    
}
