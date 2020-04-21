//
//  PlayingDetailsViewController.swift
//  Movie
//
//  Created by Jin on 2/28/20.
//  Copyright © 2020 xcode365. All rights reserved.
//


import UIKit
import Cosmos

class PlayingDetailsViewController: UIViewController, UICollectionViewDataSource , UICollectionViewDelegate
    
{
    
    @IBOutlet weak var movieCoverImage: UIImageView!
    @IBOutlet weak var movieBackgroundImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieId: UILabel!
    @IBOutlet var cosmosView: CosmosView!
    @IBOutlet weak var moviePopularity: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    func downloadJSON(link: String, completed: @escaping () -> () )
    {
        let url = URL(string: link) 
        URLSession.shared.dataTask(with: url!)
        {
            (data, response, err) in
            if err == nil
            {
                // check downloaded JSON data
                guard let jsondata = data else
                {
                    print("Error: ", err!)
                    completed()
                    return
                }
                
                do
                {
                    self.movieResults = try JSONDecoder().decode(MovieDetails.self, from: jsondata)
                    DispatchQueue.main.async
                        {
                            completed()
                    }
                }
                catch let error
                {
                    print("Error: ", error)
                    print("JSON Downloading Error!")
                }
            }
        }.resume()
        
    }
    
    
    
    var movieCovers = [UIImage]()
    
    var movie: MovieInformation?
        
    {
        didSet
        {
            
            let id = movie?.id
            
            let link = "https://api.themoviedb.org/3/movie/" + String(id!) + "?api_key=14d118971c4e8e277c631fba14844033"
            
            downloadJSON(link: link)
            {
                // Download details of a selected movie with id
                let movie = self.movieResults
                
                
            }
        }
    }
    
    
    func getImageFromWeb(_ urlString: String, closure: @escaping (UIImage?) -> ())
    {
        print("b")
        guard let url = URL(string: urlString) else {
            return closure(nil)
        }
        let task = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("error: \(String(describing: error))")
                return closure(nil)
            }
            guard response != nil else {
                print("no response")
                return closure(nil)
            }
            guard data != nil else {
                print("no data")
                return closure(nil)
            }
            DispatchQueue.main.async {
                closure(UIImage(data: data!))
            }
        }; task.resume()
    }
    
    
    
    
    
    
    var movieResults: MovieDetails?
    var genreCollection = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DispatchQueue.main.async {
            
            
            let genreIds = (self.movie?.genre_ids)!
            print(genreIds)
            
            
            for genre in genreIds {
                switch genre {
                case 28:
                    self.genreCollection.append("Action")
                case 12:
                    self.genreCollection.append("Adventure")
                case 16:
                    self.genreCollection.append("Animation")
                case 35:
                    self.genreCollection.append("Comedy")
                case 80:
                    self.genreCollection.append("Crime")
                case 99:
                    self.genreCollection.append("Documentary")
                case 18:
                    self.genreCollection.append("Drama")
                case 10751:
                    self.genreCollection.append("Family")
                case 14:
                    self.genreCollection.append("Fantasy")
                case 36:
                    self.genreCollection.append("History")
                case 27:
                    self.genreCollection.append("Horror")
                case 10402:
                    self.genreCollection.append("Music")
                case 9648:
                    self.genreCollection.append("Mystery")
                case 10749:
                    self.genreCollection.append("Romance")
                case 878:
                    self.genreCollection.append("Science Fiction")
                case 10770:
                    self.genreCollection.append("TV Movie")
                case 53:
                    self.genreCollection.append("Thriller")
                case 10752:
                    self.genreCollection.append("War")
                    
                default:
                    self.genreCollection.append("Western")
                }
                
                
            }
            
            
            self.movieId.text = self.genreCollection.prefix(2).joined(separator: ", ")
            
            
            self.cosmosView.rating = ((self.movie?.vote_average)!)/2
            self.cosmosView.settings.fillMode = .precise
            self.cosmosView.settings.updateOnTouch = false
            self.cosmosView.settings.starSize = 30
            
            let popularity : Double = (self.movie?.popularity)!
            self.moviePopularity.text = String(popularity)
            
            self.movieNameLabel.text = self.movie?.original_title
            self.movieTitleLabel.text = self.movie?.original_title
            self.movieOverviewLabel.text = self.movie?.overview!
            
            let rating : Double = (self.movie?.vote_average)!
            self.movieRating.text = String("\(rating)\\10.0")
            
            self.movieReleaseDate.text = String((self.movie?.release_date?.prefix(4) ?? "No release"))
            
            
            
            let backdrop = self.movie?.backdrop_path
            let path = self.movie?.poster_path
            var downloadedImage1 = ""
            var downloadedImage = ""
            if backdrop  != nil && path != nil
                
            {
                downloadedImage1 = "https://image.tmdb.org/t/p/w780/" + String(backdrop!)
                downloadedImage = "https://image.tmdb.org/t/p/w780/" + path!
            }
            
            self.getImageFromWeb(downloadedImage1) { (image1) in
                
                if let image1 = image1
                {
                    self.getImageFromWeb(downloadedImage) { (image) in
                        if let image = image {
                            
                            self.movieBackgroundImage.image = image1
                            self.movieCoverImage.image = image
                            
                            self.collectionView.dataSource = self
                            self.collectionView.delegate = self
                            self.movieCovers.append(image)
                            self.movieCovers.append(image1)
                            self.movieCovers.append(image)
                            self.movieCovers.append(image1)
                        }
                        
                    }
                }
                
                
            }
            
        }
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            
            //self.title = movieResults?.original_title as? String
            self.movieNameLabel.text = self.movie?.original_title
            self.movieTitleLabel.text = self.movie?.original_title
            self.movieOverviewLabel.text = self.movie?.overview!
            
            
            self.movieOverviewLabel.text = self.movie?.overview!
            self.movieReleaseDate.text = String((self.movie?.release_date?.prefix(4) ?? "No release"))
            
            
            let backdrop = self.movie?.backdrop_path
            var downloadedImage1 = ""
            if backdrop  != nil
            {
                downloadedImage1 = "https://image.tmdb.org/t/p/w780/" + String(backdrop!)
            }
            self.getImageFromWeb(downloadedImage1) { (image1) in
                if let image1 = image1
                {
                    self.movieBackgroundImage.image = image1
                }
            }
            
            
            
            
            let path = self.movie?.poster_path
            var downloadedImage = ""
            if path != nil
            {
                //downloadedImage = "https://image.tmdb.org/t/p/w342/" + String(path!)
                downloadedImage = "https://image.tmdb.org/t/p/w342/" + path!
            }
            self.getImageFromWeb(downloadedImage) { (image) in
                if let image = image
                {
                    self.movieCoverImage.image = image
                }
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieCovers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TopCollectionViewCell
        
        cell.movieCollectionImage.image = self.movieCovers[indexPath.row]
        return cell
    }
    
    
}

