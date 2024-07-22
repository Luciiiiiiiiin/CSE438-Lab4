//
//  ViewController.swift
//  Lab4
//
//  Created by Yuxuan Liu on 2024/7/17.
//


import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [Movie] = []
    var cachedImages = [UIImage]()
    
    // Spinner
    let spinner = UIActivityIndicatorView(style: .large)
    
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
        
        // Set up spinner
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.item]
        let detailVC = MovieDetailViewController()
        detailVC.movieID = selectedMovie.id
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 250) // Fixed item size
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        fetchMovies(query: query)
    }
    
    // Fetch movies based on query
    func fetchMovies(query: String) {
        let apiKey = "bb619457f11db06fe46774f6a24882b3"
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(query)&page=1&per_page=20"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // Show spinner
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.spinner.stopAnimating() // Hide spinner once request is complete
            }
            
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
                self.cacheImages(theData: self.movies)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    // Cache images function
    func cacheImages(theData: [Movie]) {
        let imageCache = NSCache<NSString, UIImage>()
        
        for item in theData {
            if let posterPath = item.poster_path {
                let urlString = "https://image.tmdb.org/t/p/w500\(posterPath)"
                if let cachedImage = imageCache.object(forKey: urlString as NSString) {
                    // Use the cached image
                    print("Image fetched from cache for URL: \(urlString)")
                    cachedImages.append(cachedImage)
                } else {
                    if let url = URL(string: urlString) {
                        do {
                            let data = try Data(contentsOf: url)
                            if let image = UIImage(data: data) {
                                // Cache the image
                                imageCache.setObject(image, forKey: urlString as NSString)
                                cachedImages.append(image)
                                print("Image downloaded and cached for URL: \(urlString)")
                            } else {
                                print("Failed to create image from data for URL: \(urlString)")
                            }
                        } catch {
                            print("Failed to download data for URL: \(urlString), error: \(error.localizedDescription)")
                        }
                    }
                }
            } else {
                print("Invalid URL for item: \(item)")
            }
        }
    }
}
