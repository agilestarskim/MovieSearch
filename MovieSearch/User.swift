//
//  User.swift
//  Prography
//
//  Created by 김민성 on 2023/02/04.
//

import Foundation

/**
 앱 전역에서 사용하는 유저정보를 담은 클래스
 북마크와 좋아요 누른 영화를 저장한다.
 */
class User: ObservableObject {
    @Published var bookmarkedMovies: [Movie] = [] {
        didSet {
            saveMovie(bookmarkedMovies)
        }
    }
    @Published var likeMovieIds: [Int] = [] {
        didSet {
            saveLike(likeMovieIds)
        }
    }
    
    init() {
        loadMovie()
        loadLike()
    }
    
    func isBookmarked(selectedMovie: Movie) -> Bool {        
        return bookmarkedMovies.contains(selectedMovie)
    }
    
    func isLike(selectedMovieId: Int) -> Bool {
        return likeMovieIds.contains(selectedMovieId)
    }
    
    func saveMovie(_ movies: [Movie]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(movies) {
            UserDefaults.standard.set(encoded, forKey: "savedBookmarkedMovies")
        }
    }
    
    func saveLike(_ id: [Int]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(id) {
            UserDefaults.standard.set(encoded, forKey: "savedLike")
        }
    }
    
    func loadMovie() {
        if let data = UserDefaults.standard.object(forKey: "savedBookmarkedMovies") as? Foundation.Data {
            let decoder = JSONDecoder()
            if let savedBookmarkedMovies = try? decoder.decode([Movie].self, from: data) {
                bookmarkedMovies = savedBookmarkedMovies
            }
        }
    }
    
    func loadLike() {
        if let data = UserDefaults.standard.object(forKey: "savedLike") as? Foundation.Data {
            let decoder = JSONDecoder()
            if let savedLike = try? decoder.decode([Int].self, from: data) {
                likeMovieIds = savedLike
            }
        }
    }
}
