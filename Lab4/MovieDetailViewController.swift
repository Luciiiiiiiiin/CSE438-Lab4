//
//  MovieDetailViewController..swift
//  Lab4
//
//  Created by Yuxuan Liu on 2024/7/22.
//

import UIKit
import WebKit

class MovieDetailViewController: UIViewController {
    var movieID: Int?
    var movie: Movie?
    var trailers: [Trailer] = []
    
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
        imageView.isUserInteractionEnabled = true // Enable user interaction
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
    
    let playTrailerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Play Trailer", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        if let movieID = movieID {
            fetchMovieDetails(movieID: movieID)
            fetchMovieTrailers(movieID: movieID)
        }
        
        // Add long press gesture recognizer to imageView
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        imageView.addGestureRecognizer(longPressRecognizer)
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
        contentView.addSubview(playTrailerButton)
        
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
            
            // PlayTrailerButton constraints
            playTrailerButton.topAnchor.constraint(equalTo: favoriteButton.bottomAnchor, constant: 20),
            playTrailerButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            playTrailerButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        favoriteButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        playTrailerButton.addTarget(self, action: #selector(playTrailer), for: .touchUpInside)
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
    
    func fetchMovieTrailers(movieID: Int) {
        let apiKey = "bb619457f11db06fe46774f6a24882b3"
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching trailers: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let trailerResults = try decoder.decode(TrailerResults.self, from: data)
                self.trailers = trailerResults.results.filter { $0.site == "YouTube" }
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
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            guard let image = imageView.image else { return }
            let alert = UIAlertController(title: "Save Image", message: "Do you want to save this image to your photos?", preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alert = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func playTrailer() {
        guard let trailer = trailers.first else {
            let alert = UIAlertController(title: "No Trailer", message: "No trailer available for this movie.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let urlString = "https://www.youtube.com/watch?v=\(trailer.key)"
        print("Trailer URL: \(urlString)") // Debugging print statement
        
        if let url = URL(string: urlString) {
            let webView = WKWebView(frame: self.view.bounds)
            let request = URLRequest(url: url)
            webView.load(request)
            
            let webViewController = UIViewController()
            webViewController.view.addSubview(webView)
            webView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                webView.leadingAnchor.constraint(equalTo: webViewController.view.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: webViewController.view.trailingAnchor),
                webView.topAnchor.constraint(equalTo: webViewController.view.topAnchor),
                webView.bottomAnchor.constraint(equalTo: webViewController.view.bottomAnchor)
            ])
            
            self.present(webViewController, animated: true, completion: nil)
        } else {
            print("Invalid URL")
        }
    }
}
