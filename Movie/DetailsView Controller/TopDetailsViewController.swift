//
//  TopDetailsViewController.swift
//  Movie
//
//  Created by Jin on 2/25/20.
//  Copyright © 2020 xcode365. All rights reserved.
//

import UIKit
import Cosmos
import Firebase
//import FirebaseUI

class TopDetailsViewController: UIViewController, UICollectionViewDataSource , UICollectionViewDelegate, ReviewCellDelegate
    
{
    @IBOutlet weak var BtnPost: UIButton!
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tlbReviewHeight: NSLayoutConstraint!
    @IBOutlet weak var tlbReview: UITableView!
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
    
    var curMovieID : String = ""
    var comment = [String : AnyObject]()
    var aryComment : [[String : Any]] = []
    var bEditFlag : Bool = false
    var selectedComment : [String : Any] = [:]
    var currentUser : [String : Any] = [:]
    
    var movie: MovieInformation?
    {
        didSet
        {
            let id = movie?.id
            curMovieID = String(id!)
            
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
        
        self.BtnPost.isEnabled = false
        getCurrentUserInfo()
        
        tlbReview.rowHeight = UITableView.automaticDimension
        tlbReview.estimatedRowHeight = 120
        tlbReview.delegate = self
        tlbReview.dataSource = self
        tlbReview.showsHorizontalScrollIndicator = false
        tlbReview.showsVerticalScrollIndicator = false
        tlbReview.tableFooterView = UIView.init(frame: .zero)
        
        tlbReviewHeight.constant = CGFloat ()
        
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
    
    override func viewDidLayoutSubviews() {
        self.tlbReviewHeight.constant = CGFloat(5 * 150)
        self.imgUser.layer.cornerRadius = self.imgUser.frame.height / 2
        self.imgUser.clipsToBounds = true
        self.BtnPost.layer.cornerRadius = 5.0
        self.BtnPost.clipsToBounds = true
        setScrollViewContentSize()
        getComments()
    }
    
    @objc func setScrollViewContentSize() {
        scrollView.contentSize = CGSize.init(width: self.view.frame.width, height: tlbReview.frame.origin.y + tlbReviewHeight.constant)
        tlbReview.superview?.translatesAutoresizingMaskIntoConstraints = true
        tlbReview.superview?.frame = CGRect.init(x: (tlbReview.superview?.frame.origin.x)!, y: (tlbReview.superview?.frame.origin.y)!, width: self.view.frame.size.width, height: scrollView.contentSize.height)
    }
    
    @objc func setTableViewHeith() {
        self.tlbReviewHeight.constant = self.tlbReview.contentSize.height
        self.setScrollViewContentSize()
    }
    
    
    
    @IBAction func onClickPostAction(_ sender: UIButton) {
        
        //************************* Apr 21 2020, SmartEye *******************************//
        
        let strComment = txtComment.text?.TrimString()
        if strComment == "" {
            self.ShowAlertMessage("Error!", "Please write your comment.")
        }else{
            comment["movieid"] = curMovieID as AnyObject
            comment["detail"] = strComment as AnyObject
            comment["ownerId"] = Auth.auth().currentUser?.uid as AnyObject
            comment["like"] =  [] as AnyObject
            comment["dislike"] = [] as AnyObject            
            //********************************************//
            comment["ownerName"] = currentUser["Fullname"] as AnyObject
            comment["ownerImage"] = currentUser["imageUrl"] as AnyObject
            //********************************************//
            
            if bEditFlag {
                let commentId = selectedComment["id"] as? String
                
                Firestore.firestore().collection("Comments").document(commentId!).updateData(["detail": strComment as Any]) { err in
                    if let err = err {
                        self.ShowAlertMessage("Error!", "Error Edit comment : \(err)")
                    } else {
                        self.bEditFlag = false
                        self.txtComment.text = ""
                        self.setPostButton()
                        self.getComments()
                    }
                }
            } else {
                Firestore.firestore().collection("Comments").addDocument( data : comment ) { err in
                    if let err = err {
                        self.ShowAlertMessage("Error!", "Error post your comment : \(err)")
                    } else {
                        self.bEditFlag = false
                        self.txtComment.text = ""
                        self.setPostButton()
                        self.getComments()
                        
                        // Update numbers of reviews.
                        let ref = Firestore.firestore().collection("Reviews")
                        ref.whereField("movieid", isEqualTo: self.curMovieID)
                           .getDocuments() { querySnapshot, error in
                            guard let documents = querySnapshot?.documents else {
                                print("Error fetching documents: \(error!)")
                                return
                            }
                            if documents.count == 0 {
                                Firestore.firestore().collection("Reviews").addDocument( data : ["movieid": self.curMovieID, "reviews": 1] ) { err in
                                    if let err = err {
                                        print("Error update reviews : \(err)")
                                    } else {
                                        print("Succesed  update reviews ")
                                    }
                                }
                            }else {
                                for document in documents {
                                    let currentReviews = document["reviews"] as! Int
                                   Firestore.firestore().collection("Reviews").document(document.documentID).updateData(["reviews": currentReviews + 1]) { err in
                                       if let err = err {
                                           self.ShowAlertMessage("Error!", "Error update reviews : \(err)")
                                       } else {
                                           print("Succesed  update reviews ")
                                       }
                                   }
                                }
                            }
                        }
                        // Update numbers of reviews.
                    }
                }
            }
        }
    }
    
    func getComments() {
        let ref = Firestore.firestore().collection("Comments")
        ref.whereField("movieid", isEqualTo: curMovieID)
           .getDocuments() { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.aryComment.removeAll()
            for document in documents{
               self.aryComment.append(["data" : document.data(), "id": document.documentID])
            }
            self.tlbReview.reloadData()
        }
    }
        
    func didLike(index: Int) {
        let currentId = Auth.auth().currentUser?.uid
        let comment = aryComment[index]
        
        let commentId = comment["id"] as? String
        let commentData = comment["data"] as! [String: Any]
        var aryLike = commentData["like"] as? [String]
        var aryDislike = commentData["dislike"] as? [String]
        
        if aryDislike!.count > 0 {
            if let index = aryDislike!.firstIndex(of: currentId!){
                aryDislike!.remove(at: index)
            }
        }
        if aryLike!.count > 0 {
            if !aryLike!.contains(currentId!){
                aryLike!.append(currentId!)
            }
        } else {
            aryLike!.append(currentId!)
        }
        
        Firestore.firestore().collection("Comments").document(commentId!).updateData(["like": aryLike as Any, "dislike": aryDislike as Any]) { err in
            if let err = err {
                self.ShowAlertMessage("Error!", "Error like comment : \(err)")
            } else {
                self.getComments()
            }
        }
        
    }
    
    func didDislike(index: Int) {
        let currentId = Auth.auth().currentUser?.uid
        let comment = aryComment[index]
        
        let commentId = comment["id"] as? String
        let commentData = comment["data"] as! [String: Any]
        var aryLike = commentData["like"] as? [String]
        var aryDislike = commentData["dislike"] as? [String]
        
        if aryLike!.count > 0 {
            if let index = aryLike!.firstIndex(of: currentId!){
                aryLike!.remove(at: index)
            }
        }
        
        if aryDislike!.count > 0 {
            if !aryDislike!.contains(currentId!){
                aryDislike!.append(currentId!)
            }
        } else {
            aryDislike!.append(currentId!)
        }
        
        Firestore.firestore().collection("Comments").document(commentId!).updateData(["like": aryLike as Any, "dislike": aryDislike as Any]) { err in
            if let err = err {
                self.ShowAlertMessage("Error!", "Error like comment : \(err)")
            } else {
                self.getComments()
            }
        }
    }
    
    func didEdit(index: Int) {
        bEditFlag = true
        selectedComment = aryComment[index]
        let commentData = selectedComment["data"] as! [String: Any]
        let commentDetail = commentData["detail"] as? String
        self.txtComment.text = commentDetail
        
        setPostButton()
    }
    
    func didRemove(index: Int) {
        let comment = aryComment[index]
        let commentId = comment["id"] as? String
        Firestore.firestore().collection("Comments").document(commentId!).delete() { err in
            if let err = err {
                self.ShowAlertMessage("Error!", "Error remove your comment : \(err)")
            } else {
                self.ShowAlertMessage("Success!", "Comment successfully removed!")
                self.getComments()
                
                
                // Update numbers of reviews.
                let ref = Firestore.firestore().collection("Reviews")
                ref.whereField("movieid", isEqualTo: self.curMovieID)
                   .getDocuments() { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching documents: \(error!)")
                        return
                    }
                    for document in documents {
                        let currentReviews = document["reviews"] as! Int
                       Firestore.firestore().collection("Reviews").document(document.documentID).updateData(["reviews": currentReviews - 1]) { err in
                           if let err = err {
                               self.ShowAlertMessage("Error!", "Error update reviews : \(err)")
                           } else {
                               print("Succesed  update reviews ")
                           }
                       }
                    }
                }
                // Update numbers of reviews.
                
                
            }
        }
    }
    
    func setPostButton() {
        if bEditFlag {
            self.BtnPost.setTitle("Done", for: .normal)
        } else {
            self.BtnPost.setTitle("Post", for: .normal)
        }
    }
    
    func getCurrentUserInfo() {
        let userID = Auth.auth().currentUser?.uid
        let query = Database.database().reference().child("users").child(userID!)
        query.observe( .value, with: { (snapshot) in
            self.currentUser = snapshot.value as? [String: AnyObject] ?? [:]
            self.BtnPost.isEnabled = true
                        
            let url = self.currentUser["imageUrl"] as! String
            let storageRef = Storage.storage().reference(forURL: url)
            storageRef.getData(maxSize: 512 * 512, completion: {(data, error) -> Void in
                let pic = UIImage(data: data!)
                self.imgUser.image = pic
            })
        })
    }
    
    //********************************************************//
    
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


extension UIImage
{
    func resized(withPercentage percentage: CGFloat) -> UIImage?
    {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer
        {
            UIGraphicsEndImageContext()
        }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
        
    }
    func resized(toWidth width: CGFloat) -> UIImage?
    {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer
        {
            UIGraphicsEndImageContext()
        }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension TopDetailsViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return aryComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tlbReview.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as! ReviewCell
        cell.minHeight = 150
        cell.selectionStyle = .none
        self.perform(#selector(setTableViewHeith), with: nil, afterDelay: 0.001)
        
        let comment = aryComment[indexPath.row]
        let commentData = comment["data"] as! [String: Any]

        let url = commentData["ownerImage"] as! String
        let storageRef = Storage.storage().reference(forURL: url)
        storageRef.getData(maxSize: 512 * 512, completion: {(data, error) -> Void in
            let pic = UIImage(data: data!)
            cell.imgUser.image = pic
        })
//        cell.imgUser.downloadedFrom(url: URL(string: url)!)
        
        cell.lblname.text = commentData["ownerName"] as? String
        cell.lblcomment.text = commentData["detail"] as? String
        
        let aryLikes = commentData["like"] as? NSArray
        if aryLikes!.count == 0 {
            cell.lbllikes.text = "likes"
        } else {
            cell.lbllikes.text = "\(aryLikes!.count ) likes"
        }
        
        let arydisikes = commentData["dislike"] as? NSArray
        if arydisikes!.count == 0 {
            cell.lblDislikes.text = "disikes"
        } else {
            cell.lblDislikes.text = "\(arydisikes!.count ) dislikes"
        }
        
        let currentId = Auth.auth().currentUser?.uid
        let ownerId = commentData["ownerId"] as? String
        if currentId == ownerId {
            cell.BtnEdit.isHidden = false
            cell.BtnRemove.isHidden = false
            cell.BtnLike.isEnabled = false
            cell.BtnDislike.isEnabled = false
        } else {
            cell.BtnEdit.isHidden = true
            cell.BtnRemove.isHidden = true
            cell.BtnLike.isEnabled = true
            cell.BtnDislike.isEnabled = true
        }
        
        let aryLike = commentData["like"] as? [String]
        let aryDislike = commentData["dislike"] as? [String]
        
        let imgLetter = UIImage(named: "like")
        let stencil = imgLetter?.withRenderingMode(.alwaysTemplate)
        cell.BtnLike.setImage(stencil, for: .normal)
        
        if aryLike!.count > 0 {
            if aryLike!.contains(currentId!){
                cell.BtnLike.isEnabled = false
                // Set imagecolor of UIButton
                cell.BtnLike.tintColor = .blue
            } else {
                cell.BtnLike.tintColor = .black
            }
        } else {
            cell.BtnLike.tintColor = .black
        }
        
        
        let imgLetter1 = UIImage(named: "dislike")
        let stencil1 = imgLetter1?.withRenderingMode(.alwaysTemplate)
        cell.BtnDislike.setImage(stencil1, for: .normal)
        if aryDislike!.count > 0 {
            if aryDislike!.contains(currentId!){
                cell.BtnDislike.isEnabled = false
                
                // Set imagecolor of UIButton
                cell.BtnDislike.tintColor = .blue
            }else {
                cell.BtnDislike.tintColor = .black
            }
        }else {
            cell.BtnDislike.tintColor = .black
        }
        
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }
}

extension TopDetailsViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

