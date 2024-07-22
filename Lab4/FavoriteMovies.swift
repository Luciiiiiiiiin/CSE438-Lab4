//
//  FavoriteMovies.swift
//  Lab4
//
//  Created by Yuxuan Liu on 2024/7/22.
//

import Foundation

class FavoriteMovies {
    static let shared = FavoriteMovies()
    private var favorites: [Movie] = []
    private let favoritesKey = "favoriteMovies"
    
    private init() {
        loadFavorites()
    }
    
    func add(movie: Movie) {
        if !favorites.contains(where: { $0.id == movie.id }) {
            favorites.append(movie)
            saveFavorites()
        }
    }
    
    func remove(at index: Int) {
        favorites.remove(at: index)
        saveFavorites()
    }
    
    func all() -> [Movie] {
        return favorites
    }
    
    private func saveFavorites() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    private func loadFavorites() {
        if let savedFavorites = UserDefaults.standard.object(forKey: favoritesKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedFavorites = try? decoder.decode([Movie].self, from: savedFavorites) {
                favorites = loadedFavorites
            }
        }
    }
}
