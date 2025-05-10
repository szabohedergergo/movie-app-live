//
//  FavoritesManager.swift
//  movie-app-live
//
//  Created by Gergo Szabo on 2025. 05. 04..
//

import Foundation
import Combine

class FavoritesManager: ObservableObject {
    static let manager = FavoritesManager()
    
    @Published private(set) var favoriteMovieIDs: Set<Int> = []
    
    private let key = "favoriteMovieIDs"
    
    private init(){
        guard let data = UserDefaults.standard.array(forKey: key) as? [Int] else {
            return
        }
        
        favoriteMovieIDs = Set(data)
    }
    
    func isFavorite(id: Int) -> Bool {
        favoriteMovieIDs.contains(id)
    }
    
    func toggleFavorite(id: Int) {
        if !favoriteMovieIDs.contains(id){
            favoriteMovieIDs.insert(id)
        }
        else{
            favoriteMovieIDs.remove(id)
        }
        print("Current favorites: \(favoriteMovieIDs)")
        print("Current favorites COUNT: \(favoriteMovieIDs.count)")
    }
    
    private func save(){
        UserDefaults.standard.set(Array(favoriteMovieIDs), forKey: key)
    }
}
