//
//  MovieDetailsView.swift
//  Movie
//
//  Created by Jin on 2/24/20.
//  Copyright © 2020 xcode365. All rights reserved.
//


import UIKit
import Foundation

struct Genre: Decodable
{
    let id: Int?
    let name: String?
    
}

struct MovieDetails: Decodable
    
{
    let id: Int?
    let original_title: String?
    let poster_path: String?
    let backdrop_path: String?
    var genres: [Genre]?
    let overview: String?
    let vote_average: Double?
    var vote_count: Int?
    let release_date: String?
    let original_language: String?
    var revenue : Int?
    var popularity : Double?
    var budget : Int?
    let imdb_id : String?
    let status : String?
    var runtime: Int?
    

    
    private enum CodingKeys: String, CodingKey
    {
        case id, original_title = "original_title", poster_path, backdrop_path, genres, overview, vote_average, vote_count, release_date, original_language, revenue, popularity, budget, imdb_id, status, runtime
    }
}

