//
//  HomeViewModel.swift
//  Prography
//
//  Created by 김민성 on 2023/02/04.
//

import Foundation
import Combine
import Alamofire

extension MainView {
    class ViewModel: ObservableObject {
        
        var subscription = Set<AnyCancellable>()
        @Published var movies: [Movie] = []
        @Published var selectedGenre: Genre = .all {
            didSet {
                setParameter(key: .genre, value: selectedGenre)
            }
        }
        @Published var selectedSorting: Sorting = .none {
            didSet {
                setParameter(key: .sorting, value: selectedSorting)
            }
        }
        @Published var currentPage: Int = 1 {
            didSet {
                setParameter(key: .page, value: currentPage)
            }
        }
        @Published var showingMovie: Movie? = nil {
            willSet {
                if self.movies.last == newValue {
                    currentPage += 1
                }
            }
        }
        @Published var isLoaded: Bool = false
        @Published var isAppended: Bool = false
        
        var baseURL = "https://yts.mx/api/v2/list_movies.json"
        
        var parameter: Parameters = [
            "limit": 8,
            "page": 1,
            "genre": "",
            "sort_by": "like_count"
        ]
        
        init() {
            fetchMovies()
        }
        
        func fetchMovies() {
            self.isLoaded = false
            AF.request(baseURL, parameters: parameter)
                .publishDecodable(type: Respose.self)
                .compactMap{ $0.value }
                .map { $0.data.movies}
                .sink { [weak self] completion in
                    guard let self = self else { return }
                    self.isLoaded = true
                } receiveValue: { [weak self] movies in
                    guard let self = self else { return }
                    self.movies = movies
                    debugPrint(self.movies)
                }.store(in: &subscription)
        }
        
        func appendMovies() {
            self.isAppended = false
            AF.request(baseURL, parameters: parameter)
                .publishDecodable(type: Respose.self)
                .compactMap{ $0.value }
                .map { $0.data.movies}
                .sink { [weak self] completion in
                    guard let self = self else { return }
                    self.isAppended = true
                } receiveValue: { [weak self] movies in
                    guard let self = self else { return }
                    self.movies += movies
                    debugPrint(self.movies)
                }.store(in: &subscription)
        }
        
        func setParameter(key: ParamKey, value: Any) {
            switch key {
            case .page:
                guard let value = value as? Int else { return }
                self.parameter["page"] = value + 1
                appendMovies()
            case .sorting:
                guard let value = value as? Sorting else { return }
                self.parameter["page"] = 1
                switch value {
                case .none:
                    self.parameter["sort_by"] = "like_count"
                case .title:
                    self.parameter["sort_by"] = "title"
                case .year:
                    self.parameter["sort_by"] = "year"
                case .rating:
                    self.parameter["sort_by"] = "rating"
                case .likeCount:
                    self.parameter["sort_by"] = "like_count"
                case .downloadCount:
                    self.parameter["sort_by"] = "download_count"
                }
                fetchMovies()
            case .genre:
                guard let value = value as? Genre else { return }
                self.parameter["page"] = 1
                switch value {
                case .all:
                    self.parameter["genre"] = ""
                case .action:
                    self.parameter["genre"] = "Action"
                case .adventure:
                    self.parameter["genre"] = "Adventure"
                case .animation:
                    self.parameter["genre"] = "Animation"
                case .comedy:
                    self.parameter["genre"] = "Comedy"
                case .crime:
                    self.parameter["genre"] = "Crime"
                case .documentary:
                    self.parameter["genre"] = "Documentary"
                case .drama:
                    self.parameter["genre"] = "Drama"
                case .fantasy:
                    self.parameter["genre"] = "Fantasy"
                case .horror:
                    self.parameter["genre"] = "Horror"
                case .mystery:
                    self.parameter["genre"] = "Mystery"
                case .romance:
                    self.parameter["genre"] = "Romance"
                case .scifi:
                    self.parameter["genre"] = "Sci-Fi"
                case .thriller:
                    self.parameter["genre"] = "Thriller"
                case .war:
                    self.parameter["genre"] = "War"
                }
                fetchMovies()
            }
            
        }
    }
    
    enum ParamKey {
        case page, genre, sorting
    }
    
    enum Genre: String, CaseIterable {
        case all = "전체"
        case action = "액션"
        case adventure = "어드벤쳐"
        case animation = "애니메이션"
        case comedy = "코미디"
        case crime = "범죄"
        case documentary = "다큐멘터리"
        case drama = "드라마"
        case fantasy = "판타지"
        case horror = "호러"
        case mystery = "미스테리"
        case romance = "로맨스"
        case scifi = "SF"        
        case thriller = "스릴러"
        case war = "전쟁"
    }
    
    enum Sorting: String, CaseIterable {
        case none = "기본 순"
        case title = "이름 순"
        case year = "개봉 순"
        case rating = "평점 순"
        case likeCount = "좋아요 순"
        case downloadCount = "다운로드 순"
    }
}
