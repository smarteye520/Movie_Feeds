//
//  MovieInformation.swift
//  Movie
//
//  Created by Jin on 2/23/20.
//  Copyright © 2020 xcode365. All rights reserved.
//

import UIKit
import Foundation

struct MovieInformation : Decodable
    
{
 
    var id: Int?
    var poster_path: String?
    var title: String?
    var release_date: String?
    var vote_average: Double?
    var original_language: String?
    var overview : String?
    var genre_ids : [Int]?
    var original_title: String?
    var backdrop_path: String?
    var revenue : Int?
    var popularity : Double?
    var budget : Int?
    let imdb_id : String?
    var status : String?
    var runtime: Int?

    init(id: Int, poster_path: String, title: String, release_date : String, vote_average: Double, original_language : String, overview : String, genre_ids: [Int], original_title : String, backdrop_path : String, revenue : Int, popularity : Double, budget : Int, imdb_id : String,  status : String, runtime : Int)
    {
    
        self.id = id
        self.poster_path = poster_path
        self.title = title
        self.release_date = release_date
        self.vote_average = vote_average
        self.original_language = original_language
        self.overview = overview
        self.genre_ids = genre_ids
        self.original_title = original_title
        self.backdrop_path = backdrop_path
        self.revenue = revenue
        self.popularity = popularity
        self.budget = budget
        self.imdb_id = imdb_id
        self.status = status
        self.runtime = runtime
      
}

}

struct MovieResults: Decodable
{
    let page: Int?
    let total_results: Int?
    let total_pages: Int?
    var results: [MovieInformation]?
    
    private enum CodingKeys: String, CodingKey
    {
        case page, total_results, total_pages, results
    }
}


