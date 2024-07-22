//
//  MovieCellCollectionViewCell.swift
//  Lab4
//
//  Created by Yuxuan Liu on 2024/7/21.
//

//import UIKit
//
//class MovieCell: UICollectionViewCell {
//    static let imageCache = NSCache<NSString, UIImage>()
//    
//    let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleToFill
//        imageView.clipsToBounds = true
//        return imageView
//    }()
//    
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.font = UIFont.boldSystemFont(ofSize: 14)
//        label.textColor = .white
//        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        label.numberOfLines = 0
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        // Add border to the cell
//        self.layer.borderColor = UIColor.black.cgColor
//        self.layer.borderWidth = 1.0
//        
//        contentView.addSubview(imageView)
//        imageView.addSubview(titleLabel)
//        
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            // Fill the image inside the MovieCell
//            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            imageView.widthAnchor.constraint(equalToConstant: 150), // Fixed width for image view
//            imageView.heightAnchor.constraint(equalToConstant: 250), // Fixed height for image view
//            
//            // Set label at the bottom of the imageView
//            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 0),
//            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0),
//            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0)
//        ])
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func configure(with movie: Movie) {
//        titleLabel.text = movie.title
//        if let posterPath = movie.poster_path {
//            let urlString = "https://image.tmdb.org/t/p/w500\(posterPath)" as NSString
//            
//            // Check if the image is cached
//            if let cachedImage = MovieCell.imageCache.object(forKey: urlString) {
//                print("Image fetched from cache for URL: \(urlString)")
//                imageView.image = cachedImage
//            } else {
//                // If not cached, download the image
//                if let url = URL(string: urlString as String) {
//                    URLSession.shared.dataTask(with: url) { data, response, error in
//                        if let data = data, let image = UIImage(data: data) {
//                            // Cache the image
//                            MovieCell.imageCache.setObject(image, forKey: urlString)
//                            DispatchQueue.main.async {
//                                self.imageView.image = image
//                            }
//                            print("Image downloaded and cached for URL: \(urlString)")
//                        } else {
//                            print("Failed to create image from data for URL: \(urlString)")
//                        }
//                    }.resume()
//                }
//            }
//        }
//    }
//}

import UIKit

class MovieCell: UICollectionViewCell {
    static let imageCache = NSCache<NSString, UIImage>()
    static let identifier = "MovieCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add border to the cell
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        
        contentView.addSubview(imageView)
        imageView.addSubview(titleLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Fill the image inside the MovieCell
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150), // Fixed width for image view
            imageView.heightAnchor.constraint(equalToConstant: 250), // Fixed height for image view
            
            // Set label at the bottom of the imageView
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0)
        ])
        
        // Enable context menu interaction
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        if let posterPath = movie.poster_path {
            let urlString = "https://image.tmdb.org/t/p/w500\(posterPath)" as NSString
            
            // Check if the image is cached
            if let cachedImage = MovieCell.imageCache.object(forKey: urlString) {
                print("Image fetched from cache for URL: \(urlString)")
                imageView.image = cachedImage
            } else {
                // If not cached, download the image
                if let url = URL(string: urlString as String) {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        if let data = data, let image = UIImage(data: data) {
                            // Cache the image
                            MovieCell.imageCache.setObject(image, forKey: urlString)
                            DispatchQueue.main.async {
                                self.imageView.image = image
                            }
                            print("Image downloaded and cached for URL: \(urlString)")
                        } else {
                            print("Failed to create image from data for URL: \(urlString)")
                        }
                    }.resume()
                }
            }
        }
    }
}

// MARK: - UIContextMenuInteractionDelegate
extension MovieCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let addToFavorites = UIAction(title: "Add to Favorites", image: UIImage(systemName: "star.fill")) { action in
                NotificationCenter.default.post(name: .addToFavorites, object: self)
            }
            return UIMenu(title: "", children: [addToFavorites])
        }
    }
}

// Define a notification name for adding to favorites
extension Notification.Name {
    static let addToFavorites = Notification.Name("addToFavorites")
}
