//
//  MovieDetail.swift
//  Prography
//
//  Created by 김민성 on 2023/02/05.
//

import Foundation


struct Respose: Decodable {
    let status: String
    let statusMessage: String
    let data: Data
    
    enum CodingKeys: String, CodingKey {
        case status, data
        case statusMessage = "status_message"
    }
}
    
struct Data: Decodable {
    let movieCount: Int?
    let movie: Movie?
    let movies: [Movie]?
    
    enum CodingKeys: String, CodingKey {
        case movies, movie
        case movieCount = "movie_count"
    }
}
    
struct Movie: Codable, Equatable  {
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: Int
    let url: String
    let title: String
    let year: Int
    let rating: Float
    let runtime: Int
    let genres: [String]
    let summary: String?
    let smallCoverImage: String?
    let mediumCoverImage: String?
    let largeCoverImage: String?
    //detail
    let downloadCount: Int?
    let likeCount: Int?
    let descriptionIntro: String?
    
    enum CodingKeys: String, CodingKey {
        case id, url, title, year, rating, runtime, genres,summary
        case smallCoverImage = "small_cover_image"
        case mediumCoverImage = "medium_cover_image"
        case largeCoverImage = "large_cover_image"
        case downloadCount = "download_count"
        case likeCount = "like_count"
        case descriptionIntro = "description_intro"
    }
    
    var trimmedRating: String {
        return String(format: "%.1f", rating)
    }
    
    var yearString: String {
        return String(year).replacingOccurrences(of: ",", with: "")
    }
    
    var filteredSummary: String {
        guard let summary = self.summary else { return "" }
        if summary.isEmpty {
            return "등록된 줄거리가 없습니다."
        } else {
            return summary
        }
    }
    
    //preview 사용을 위해 
    static var testData: Movie {
        Movie(
            id: 13106, url: "https://yts.mx/movies/the-paper-1994", title: "Avengers: Endgame",year: 2019, rating: 8.4, runtime: 181,
            genres: ["Action","Adventure","Drama","Sci-Fi"],
            summary: "The life and times of Stiv Bators, legendary frontman of the Dead Boys and The Lords of The New Church.",
            smallCoverImage: "https://yts.mx/assets/images/movies/avengers_endgame_2019/small-cover.jpg",
            mediumCoverImage: "https://yts.mx/assets/images/movies/avengers_endgame_2019/medium-cover.jpg",
            largeCoverImage: "https://yts.mx/assets/images/movies/avengers_endgame_2019/large-cover.jpg",
            downloadCount: 7650144, likeCount: 2901,
            descriptionIntro: "After the devastating events of Avengers: Infinity War (2018), the universe is in ruins due to the efforts of the Mad Titan, Thanos. With the help of remaining allies, the Avengers must assemble once more in order to undo Thanos's actions and undo the chaos to the universe, no matter what consequences may be in store, and no matter who they face..."
            
        )
    }
}
