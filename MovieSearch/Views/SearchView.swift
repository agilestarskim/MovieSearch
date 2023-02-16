//
//  SearchView.swift
//  Prography
//
//  Created by 김민성 on 2023/02/04.
//

import SwiftUI
import Kingfisher

struct SearchView: View {
    @ObservedObject private var vm = ViewModel()
    var body: some View {
        NavigationView {
            ScrollView {
                if !vm.isSearched {
                    Text("검색 결과가 없습니다.")
                        .padding(.top, 30)
                }
                if vm.isLoaded {
                    LazyVStack {
                        ForEach(vm.movies, id: \.id) { movie in
                            NavigationLink {
                                DetailView(vm: DetailView.ViewModel(movie: movie))
                            } label: {
                                HStack(alignment: .top) {
                                    KFImage(URL(string: movie.mediumCoverImage ?? ""))
                                        .placeholder {
                                            Rectangle()
                                                .fill(.gray)
                                                .frame(width: 100, height: 120)
                                        }
                                        .resizable()
                                        .frame(width: 100, height: 120)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                    VStack(alignment: .leading) {
                                        Text(movie.title)
                                            .multilineTextAlignment(.leading)
                                        Text("평점 \(movie.trimmedRating) / 10")
                                            .font(.callout)
                                        Text("개봉 \(movie.yearString)년")
                                            .font(.callout)
                                    }
                                    .foregroundColor(.primary)
                                    Spacer()
                                }
                                .onAppear {
                                    vm.showingMovie = movie
                                }
                            }
                        }
                        if !vm.isAppended {
                            ProgressView().progressViewStyle(CircularProgressViewStyle())
                        }
                    }
                    .padding()
                } else {
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                        .padding(.top, 30)
                }
            }
            .navigationTitle("영화검색")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                UITabBar.showTabBar()
            }
        }
        .searchable(text: $vm.searchText, prompt: "영화제목을 입력하세요")
        .onSubmit(of: .search) {
            vm.fetchMovies(vm.searchText)
        }
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
