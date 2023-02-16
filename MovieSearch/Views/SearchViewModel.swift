//
//  SearchViewModel.swift
//  Prography
//
//  Created by 김민성 on 2023/02/04.
//

import SwiftUI
import Combine
import Alamofire

extension SearchView {
    class ViewModel: ObservableObject {
        //검색된 영화 목록
        @Published var movies: [Movie] = []
        @Published var searchText = ""
        
        //loading 중인지 표시하기 위해 사용
        @Published var isLoaded = true
        @Published var isAppended = true
        //검색결과가 없을 때 표시할 문구를 위해 사용
        //false일 때 "검색결과가 없습니다" 보여짐
        @Published var isSearched = true
        private var subscription = Set<AnyCancellable>()
        
        //메인뷰와 마찬가지로 무한스크롤을 위해 사용
        var currentPage: Int = 1 {
            didSet {
                self.parameters["page"] = currentPage
                self.appendMovies()
            }
        }
        //메인뷰와 원리 똑같음
        var showingMovie: Movie? = nil {
            willSet {
                if self.movies.last == newValue {
                    currentPage += 1
                }
            }
        }
        
        let baseURL = "https://yts.mx/api/v2/list_movies.json"
        var parameters: Parameters = [
            "sort_by": "like_count",
            "query_term": ""
        ]
        
        func fetchMovies(_ text: String) {
            self.parameters["query_term"] = text
            self.isLoaded = false
            self.isSearched = true
            self.currentPage = 1
            AF.request(baseURL, parameters: parameters)
                .publishDecodable(type: Respose.self)
                .compactMap{ $0.value }
                .map { $0.data }
                .sink { [weak self] completion in
                    guard let self = self else { return }
                    self.isLoaded = true
                } receiveValue: { [weak self] data in
                    guard let self = self else { return }
                    //검색결과가 없으면 "검색결과가 없습니다" 문구를 보여주고 이전 결과를 지움
                    if data.movieCount == 0 {
                        self.isSearched = false
                        self.movies = []
                    } else {
                        self.isSearched = true
                        self.movies = data.movies ?? []
                    }
                }.store(in: &subscription)
        }
        
        func appendMovies() {
            self.isAppended = false
            AF.request(baseURL, parameters: parameters)
                .publishDecodable(type: Respose.self)
                .compactMap{ $0.value }
                .compactMap { $0.data.movies }
                .sink { [weak self] completion in
                    guard let self = self else { return }
                    self.isAppended = true
                } receiveValue: { [weak self] movies in
                    guard let self = self else { return }
                    self.movies += movies
                }.store(in: &subscription)
        }
    }
}
