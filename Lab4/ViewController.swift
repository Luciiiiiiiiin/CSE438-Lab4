//
//  ViewController.swift
//  Lab4
//
//  Created by Yuxuan Liu on 2024/7/17.
//

import UIKit

struct APIResults: Codable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let poster_path: String?
    let title: String
    let release_date: String?
    let vote_average: Double
    let overview: String
    let vote_count: Int
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        // Register the custom cell programmatically
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        
        // Set up the collection view layout
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 150, height: 250) // Fixed item size
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 20
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 250) // Fixed item size
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        fetchMovies(query: query)
    }
    
    func fetchMovies(query: String) {
            let apiKey = "bb619457f11db06fe46774f6a24882b3"
            let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(query)&page=1&per_page=20"
            
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching movies: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No data")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let apiResults = try decoder.decode(APIResults.self, from: data)
                    self.movies = apiResults.results
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } catch {
                    print("Error decoding data: \(error.localizedDescription)")
                }
            }
            
            task.resume()
        }
}

