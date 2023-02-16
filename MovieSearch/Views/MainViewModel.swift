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
        //화면에 보여지는 영화
        @Published var movies: [Movie] = []
        //장르가 변경되면 API Parameter를 변경함
        @Published var selectedGenre: Genre = .all {
            didSet {
                setParameter(key: .genre, value: selectedGenre)
            }
        }
        //정렬이 변경되면 API Parameter를 변경함
        @Published var selectedSorting: Sorting = .none {
            didSet {
                setParameter(key: .sorting, value: selectedSorting)
            }
        }
        //서버에서 받아올 페이지: 마지막 영화가 화면에 보여지면 자동으로 1증가됨
        @Published var currentPage: Int = 1 {
            didSet {
                setParameter(key: .page, value: currentPage)
            }
        }
        //현재 보여지고 있는 영화 셀: LazyVStack을 이용해 화면에 나타날 때
        //마지막 영화 셀이면 currentPage를 1증가 시킴
        var showingMovie: Movie? = nil {
            willSet {
                if self.movies.last == newValue {
                    currentPage += 1
                }
            }
        }
        //loading 중인지 표시하기 위해 사용
        //isLoaded: 영화가 최초 표시될 때 또는 카테고리나 정렬을 변경했을 때 사용됨
        //isAppended: 무한스크롤을 위해 영화가 추가될 때 사용됨
        @Published var isLoaded: Bool = false
        @Published var isAppended: Bool = false
        
        var subscription = Set<AnyCancellable>()
        let baseURL = "https://yts.mx/api/v2/list_movies.json"
        
        var parameters: Parameters = [
            "limit": 8,
            "page": 1,
            "genre": "",
            "sort_by": "like_count"
        ]
        //최초 생성될 때 영화를 불러옴
        init() {
            fetchMovies()
        }
        
        //네트워크 통신 후 받아온 정보를 self.movies에 할당함
        func fetchMovies() {
            self.isLoaded = false
            AF.request(baseURL, parameters: parameters)
                .publishDecodable(type: Respose.self)
                .compactMap{ $0.value }
                .compactMap { $0.data.movies}
                .sink { [weak self] completion in
                    guard let self = self else { return }
                    self.isLoaded = true
                } receiveValue: { [weak self] movies in
                    guard let self = self else { return }
                    self.movies = movies
                }.store(in: &subscription)
        }
        //네트워크 통한 수 받아온 정보를 self.movies에 추가함
        func appendMovies() {
            self.isAppended = false
            AF.request(baseURL, parameters: parameters)
                .publishDecodable(type: Respose.self)
                .compactMap{ $0.value }
                .compactMap { $0.data.movies}
                .sink { [weak self] completion in
                    guard let self = self else { return }
                    self.isAppended = true
                } receiveValue: { [weak self] movies in
                    guard let self = self else { return }
                    self.movies += movies
                    debugPrint(self.movies)
                }.store(in: &subscription)
        }
        
        //동적인 API Parameter 변경을 위해 키 값을 받아 해당 파라미터의 키와 값을 바꿈
        //TODO: 유지보수를 위해 간단히 바꾸기
        func setParameter(key: ParamKey, value: Any) {
            switch key {
            case .page:
                guard let value = value as? Int else { return }
                self.parameters["page"] = value + 1
                appendMovies()
            case .sorting:
                guard let value = value as? Sorting else { return }
                self.parameters["page"] = 1
                switch value {
                case .none:
                    self.parameters["sort_by"] = "like_count"
                case .title:
                    self.parameters["sort_by"] = "title"
                case .year:
                    self.parameters["sort_by"] = "year"
                case .rating:
                    self.parameters["sort_by"] = "rating"
                case .likeCount:
                    self.parameters["sort_by"] = "like_count"
                case .downloadCount:
                    self.parameters["sort_by"] = "download_count"
                }
                fetchMovies()
            case .genre:
                guard let value = value as? Genre else { return }
                self.parameters["page"] = 1
                switch value {
                case .all:
                    self.parameters["genre"] = ""
                case .action:
                    self.parameters["genre"] = "Action"
                case .adventure:
                    self.parameters["genre"] = "Adventure"
                case .animation:
                    self.parameters["genre"] = "Animation"
                case .comedy:
                    self.parameters["genre"] = "Comedy"
                case .crime:
                    self.parameters["genre"] = "Crime"
                case .documentary:
                    self.parameters["genre"] = "Documentary"
                case .drama:
                    self.parameters["genre"] = "Drama"
                case .fantasy:
                    self.parameters["genre"] = "Fantasy"
                case .horror:
                    self.parameters["genre"] = "Horror"
                case .mystery:
                    self.parameters["genre"] = "Mystery"
                case .romance:
                    self.parameters["genre"] = "Romance"
                case .scifi:
                    self.parameters["genre"] = "Sci-Fi"
                case .thriller:
                    self.parameters["genre"] = "Thriller"
                case .war:
                    self.parameters["genre"] = "War"
                }
                // 파라미터를 바꾸고 바로 새로운 데이터를 요청함
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
        case none = "기본"
        case title = "이름 순"
        case year = "개봉 순"
        case rating = "평점 순"
        case likeCount = "인기 순"
        case downloadCount = "다운로드 순"
    }
}
