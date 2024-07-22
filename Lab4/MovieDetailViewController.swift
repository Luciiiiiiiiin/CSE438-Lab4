//
//  MovieDetailViewController..swift
//  Lab4
//
//  Created by Yuxuan Liu on 2024/7/22.
//

//import Foundation
//import UIKit
//
//class MovieDetailViewController: UIViewController {
//    var movieID: Int?
//    
//    let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//    
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 24)
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let overviewLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let releaseDateLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 18)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let ratingLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 18)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupUI()
//        if let movieID = movieID {
//            fetchMovieDetails(movieID: movieID)
//        }
//    }
//    
//    func setupUI() {
//        view.addSubview(imageView)
//        view.addSubview(titleLabel)
//        view.addSubview(overviewLabel)
//        view.addSubview(releaseDateLabel)
//        view.addSubview(ratingLabel)
//        
//        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            imageView.heightAnchor.constraint(equalToConstant: 300),
//            
//            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
//            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            releaseDateLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
//            releaseDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            releaseDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            ratingLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 20),
//            ratingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            ratingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//        ])
//    }
//    
//    func fetchMovieDetails(movieID: Int) {
//        let apiKey = "bb619457f11db06fe46774f6a24882b3"
//        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(apiKey)"
//        
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error fetching movie details: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let data = data else {
//                print("No data")
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                let movieDetails = try decoder.decode(Movie.self, from: data)
//                DispatchQueue.main.async {
//                    self.updateUI(with: movieDetails)
//                }
//            } catch {
//                print("Error decoding data: \(error.localizedDescription)")
//            }
//        }
//        
//        task.resume()
//    }
//    
//    func updateUI(with movie: Movie) {
//        titleLabel.text = movie.title
//        overviewLabel.text = movie.overview
//        releaseDateLabel.text = "Release Date: \(movie.release_date ?? "N/A")"
//        ratingLabel.text = "Rating: \(movie.vote_average)"
//        
//        if let posterPath = movie.poster_path {
//            let urlString = "https://image.tmdb.org/t/p/w500\(posterPath)"
//            if let url = URL(string: urlString) {
//                URLSession.shared.dataTask(with: url) { data, response, error in
//                    if let data = data, let image = UIImage(data: data) {
//                        DispatchQueue.main.async {
//                            self.imageView.image = image
//                        }
//                    }
//                }.resume()
//            }
//        }
//    }
//}

//import UIKit
//
//class MovieDetailViewController: UIViewController {
//    var movieID: Int?
//    var movie: Movie?
//    
//    let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//    
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 24)
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let overviewLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let releaseDateLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 18)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let ratingLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 18)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let favoriteButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Add to Favorites", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupUI()
//        if let movieID = movieID {
//            fetchMovieDetails(movieID: movieID)
//        }
//    }
//    
//    func setupUI() {
//        view.addSubview(imageView)
//        view.addSubview(titleLabel)
//        view.addSubview(overviewLabel)
//        view.addSubview(releaseDateLabel)
//        view.addSubview(ratingLabel)
//        view.addSubview(favoriteButton)
//        
//        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            imageView.heightAnchor.constraint(equalToConstant: 300),
//            
//            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
//            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            releaseDateLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
//            releaseDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            releaseDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            ratingLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 20),
//            ratingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            ratingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            favoriteButton.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 20),
//            favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
//        
//        favoriteButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
//    }
//    
//    func fetchMovieDetails(movieID: Int) {
//        let apiKey = "bb619457f11db06fe46774f6a24882b3"
//        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(apiKey)"
//        
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error fetching movie details: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let data = data else {
//                print("No data")
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                let movieDetails = try decoder.decode(Movie.self, from: data)
//                self.movie = movieDetails
//                DispatchQueue.main.async {
//                    self.updateUI(with: movieDetails)
//                }
//            } catch {
//                print("Error decoding data: \(error.localizedDescription)")
//            }
//        }
//        
//        task.resume()
//    }
//    
//    func updateUI(with movie: Movie) {
//        titleLabel.text = movie.title
//        overviewLabel.text = movie.overview
//        releaseDateLabel.text = "Release Date: \(movie.release_date ?? "N/A")"
//        ratingLabel.text = "Rating: \(movie.vote_average)"
//        
//        if let posterPath = movie.poster_path {
//            let urlString = "https://image.tmdb.org/t/p/w500\(posterPath)"
//            if let url = URL(string: urlString) {
//                URLSession.shared.dataTask(with: url) { data, response, error in
//                    if let data = data, let image = UIImage(data: data) {
//                        DispatchQueue.main.async {
//                            self.imageView.image = image
//                        }
//                    }
//                }.resume()
//            }
//        }
//    }
//    
//    @objc func addToFavorites() {
//        guard let movie = movie else { return }
//        FavoriteMovies.shared.add(movie: movie)
//        print("Movie added to favorites: \(movie.title)")
//    }
//}

import UIKit

class MovieDetailViewController: UIViewController {
    var movieID: Int?
    var movie: Movie?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Favorites", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        if let movieID = movieID {
            fetchMovieDetails(movieID: movieID)
        }
    }
    
    func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // ImageView constraints
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            // TitleLabel constraints
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // OverviewLabel constraints
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // ReleaseDateLabel constraints
            releaseDateLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            releaseDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // RatingLabel constraints
            ratingLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 20),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // FavoriteButton constraints
            favoriteButton.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 20),
            favoriteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            favoriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        favoriteButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
    }
    
    func fetchMovieDetails(movieID: Int) {
        let apiKey = "bb619457f11db06fe46774f6a24882b3"
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching movie details: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movieDetails = try decoder.decode(Movie.self, from: data)
                self.movie = movieDetails
                DispatchQueue.main.async {
                    self.updateUI(with: movieDetails)
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func updateUI(with movie: Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        releaseDateLabel.text = "Release Date: \(movie.release_date ?? "N/A")"
        ratingLabel.text = "Rating: \(movie.vote_average)"
        
        if let posterPath = movie.poster_path {
            let urlString = "https://image.tmdb.org/t/p/w500\(posterPath)"
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.imageView.image = image
                        }
                    }
                }.resume()
            }
        }
    }
    
    @objc func addToFavorites() {
        guard let movie = movie else { return }
        FavoriteMovies.shared.add(movie: movie)
        print("Movie added to favorites: \(movie.title)")
    }
}
