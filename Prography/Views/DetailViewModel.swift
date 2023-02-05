//
//  DetailViewModel.swift
//  Prography
//
//  Created by 김민성 on 2023/02/04.
//

import SwiftUI
import Combine
import Alamofire

extension DetailView {
    class ViewModel: ObservableObject {
        @Published var movie: Movie
        @Published var suggestionMovies: [Movie] = []
        @Published var seeMore: Bool = false
        @Published var showingAlert = false
        var subscription = Set<AnyCancellable>()
        
        //생성될 때 MainView로 부터 영화를 받은 후 디테일한 정보를 서버로 부터 받아옴
        init(movie: Movie) {
            self.movie = movie
            self.fetchMovie(movie: movie)            
        }
        
        func fetchMovie(movie: Movie) {
            let baseURL = "https://yts.mx/api/v2/movie_details.json"
            let parameters: Parameters = [
                "movie_id": movie.id,
                "with_images": true,
                "with_cast": true
            ]
            AF.request(baseURL, parameters: parameters)
                .publishDecodable(type: Respose.self)
                .compactMap { $0.value }
                .compactMap { $0.data.movie }
                .sink { completion in
                    
                } receiveValue: { [weak self] movie in
                    guard let self = self else { return }
                    self.movie = movie
                }
                .store(in: &subscription)
        }
        
        //view가 화면에 보일 때 함수가 불림
        func fetchSuggetion(movie: Movie) {
            let baseURL = "https://yts.mx/api/v2/movie_suggestions.json"
            let parameters: Parameters = ["movie_id": movie.id]
            AF.request(baseURL, parameters: parameters)
                .publishDecodable(type: Respose.self)
                .compactMap{ $0.value }
                .compactMap { $0.data.movies}
                .sink { completion in
                } receiveValue: { [weak self] movies in
                    guard let self = self else { return }
                    self.suggestionMovies = movies
                }
                .store(in: &subscription)
        }
   
        
    }
}
