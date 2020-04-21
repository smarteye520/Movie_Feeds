//
//  PopularViewController.swift
//  Movie
//
//  Created by Jin on 2/28/20.
//  Copyright © 2020 xcode365. All rights reserved.
//

import UIKit

class PopularViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Initializee results to store the data
    var results : MovieResults?
    
    // MARK: IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // viewDidLoad Function
    // JSON Downloading function from Master
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.reloadData()
        downloadJSON {
            self.collectionView.reloadData()
            print("JSON download successful")
        }
        
        
        // self.tabBarController?.title = "Top Rated"
        
        //self.navigationItem.title = "Top Rated"
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setGridLayout(size: view.frame.size, isPortrait: UIDevice.current.orientation.isPortrait)
        // Do any additional setup after loading the view.
    }
    
    
    
    func setGridLayout(size: CGSize, isPortrait: Bool) {
        // only run this if the collectionView exists to prevent crash
        if collectionView == nil { return }
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        // add y-margins
        layout.minimumLineSpacing = 4
        
        // remove extra x-margins around items
        layout.minimumInteritemSpacing = 0
        
        // set movie count and poster size in row based on device orientation
        // and give it a custom margin
        let moviesPerRow = isPortrait ? CGFloat(3) : CGFloat(4)
        let marginOffset = CGFloat(collectionView.layoutMargins.left)
        let width = (size.width - marginOffset) / moviesPerRow
        layout.estimatedItemSize = CGSize(width: width, height: width * 1.5)
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        setGridLayout(size: size, isPortrait: UIDevice.current.orientation.isPortrait)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let number = self.results?.results?.count
        {
            return number
            //return results[section].results!.count //results[section].results!.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCollectionViewCell", for: indexPath as IndexPath) as! PopularCollectionViewCell
        
        let movieName = self.results?.results![indexPath.row]
        
        let path = self.results?.results![indexPath.row].poster_path
        let downloadedImage = "https://image.tmdb.org/t/p/w154/" + path!
        self.getImageFromWeb(downloadedImage) { (image) in
            if let image = image
            {
                cell.posterView.image = image
            } // if you use an Else statement, it will be in background
        }
        
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller: PopularDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "PopularDetailsViewController") as! PopularDetailsViewController
        controller.movie = results?.results![indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
    // MARK: Download movie cover image from the internet
    func getImageFromWeb(_ urlString: String, closure: @escaping (UIImage?) -> ())
    {
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
    
    
    
    // Decode JSON data from TMDB API
    // JSON Downloading function from Master
    func downloadJSON(completed: @escaping () -> () ) {
        
        let url = URL(string:"https://api.themoviedb.org/3/movie/popular?api_key=14d118971c4e8e277c631fba14844033")
        
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            if err == nil {
                // check downloaded JSON data
                guard let jsondata = data else { return }
                do {
                    self.results = try JSONDecoder().decode(MovieResults.self, from: jsondata)
                    DispatchQueue.main.async {
                        completed()
                    }
                    
                }catch {
                    print("JSON Downloading Error!")
                    
                }
            }
        }.resume()
        
    }
    
    
}


