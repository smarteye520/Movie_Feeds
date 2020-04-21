//
//  TopRatedViewController.swift
//  Movie
//
//  Created by Jin on 2/24/20.
//  Copyright © 2020 xcode365. All rights reserved.
//

import UIKit
import Firebase

class TopRatedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Initializee results to store the data
    var results : MovieResults?
    var aryReviews : [[String : Any]] = []
    
    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    
    // viewDidLoad Function
    // JSON Downloading function from Master
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        
        downloadJSON {
            self.tableView.reloadData()
            print("JSON download successful")
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        }
        
        self.tableView.register(TopRatedTableViewCell.self, forCellReuseIdentifier: "cellidtoprated")
        
        // self.tabBarController?.title = "Top Rated"
        
        //self.navigationItem.title = "Top Rated"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getReviews()
    }
    
    func getReviews() {
        let ref = Firestore.firestore().collection("Reviews")
        ref.getDocuments() { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.aryReviews.removeAll()
            for document in documents{
               self.aryReviews.append(document.data())
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: Custom UITable View Cell
    // Set the number of rows for the UITable view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let number = self.results?.results?.count
        {
            
            return number
            
            //return results[section].results!.count //results[section].results!.count
        }
        return 0
    }
    
    // Set the number of cell for the UITable view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! TopRatedTableViewCell
                
        let movieName = self.results?.results![indexPath.row]
        let name = movieName?.title
        cell.movieTitleLabel.text = name
                
        
        let date = movieName?.release_date
        cell.movieReleaseDateLabel.text = String(date!.prefix(4))
        
        let movieDescription = self.results?.results![indexPath.row]
        let description = movieDescription?.overview
        cell.movieOverviewLabel.text = description
        
        let path = self.results?.results![indexPath.row].poster_path
        let downloadedImage = "https://image.tmdb.org/t/p/w154/" + path!
        self.getImageFromWeb(downloadedImage) { (image) in
            if let image = image
            {
                cell.movieCoverImage.image = image
            } // if you use an Else statement, it will be in background
        }
        
        let movieId = movieName?.id
        cell.lblNumbers.text = getStringofNumbers(movieId: String(movieId!))
        
        return cell
    }
    
    func getStringofNumbers(movieId: String) ->String {
        var curReviews = 0
        for review in aryReviews{
            let curMovieId = review["movieid"] as? String            
            if movieId == curMovieId {
                curReviews = review["reviews"] as! Int
                return String(curReviews)
            }
        }
        return String(curReviews)
    }
    

    // User select the row - Details View movie
    // Select a Movie and Load a Detail View
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller: TopDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "TopDetailsViewController") as! TopDetailsViewController
        controller.movie = results?.results![indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView,
                   canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle:
        UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let index = indexPath.row
            
            tableView.beginUpdates()
            self.results?.results!.remove(at: index)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.tableView.endUpdates()
            
        }
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
        
        let url = URL(string:"https://api.themoviedb.org/3/movie/top_rated?api_key=14d118971c4e8e277c631fba14844033")
        
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



extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    return
            }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link)
            else {
                return
        }
        downloadedFrom(url: url, contentMode: mode)
    }

    
}

