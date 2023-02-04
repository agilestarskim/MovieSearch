//
//  Movie.swift
//  Prography
//
//  Created by 김민성 on 2023/02/04.
//

import SwiftUI

struct Respose: Codable {
    let status: String
    let statusMessage: String
    let data: Data
    
    enum CodingKeys: String, CodingKey {
        case status, data
        case statusMessage = "status_message"
    }
}

struct Data: Codable {
    let movies: [Movie]
}

struct Movie: Codable, Equatable {
    let id: Int
    let title: String
    let year: Int
    let rating: Float
    let runtime: Int
    let genres: [String]
    let summary: String
    let largeCoverImage: String
    
    var yearString: String {
        return "(\(String(year).replacingOccurrences(of: ",", with: "")))"
    }
    
    var filteredSummary: String {
        if summary.isEmpty {
            return "등록된 줄거리가 없습니다."
        } else {
            return summary
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, year, rating, runtime, genres, summary
        case largeCoverImage = "large_cover_image"
    }
}
