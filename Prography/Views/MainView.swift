//
//  ContentView.swift
//  Prography
//
//  Created by 김민성 on 2023/02/04.
//

import SwiftUI
import Kingfisher

struct MainView: View {
    @ObservedObject private var vm = ViewModel()
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Menu {
                        ForEach(Genre.allCases, id: \.self) { genre in
                            Button("\(genre.rawValue)") {
                                vm.selectedGenre = genre
                            }
                        }
                    } label: {
                        Text((vm.selectedGenre.rawValue) + " ▼ ")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Menu {
                        ForEach(Sorting.allCases, id: \.self) { sort in
                            Button("\(sort.rawValue)") {
                                vm.selectedSorting = sort
                            }
                        }
                    } label: {
                        Text((vm.selectedSorting.rawValue) + " ▼ ")
                    }.buttonStyle(.borderedProminent)
                    Spacer()
                }
                .padding([.horizontal, .top])
                if vm.isLoaded {
                    //LazyVStack: 보이지도 않는 뷰를 미리 그리지 않고 화면에 나타나기 직전에 그림
                    LazyVStack {
                        ForEach(vm.movies, id: \.id) { movie in
                            VStack(alignment: .leading, spacing: 10){
                                HStack(alignment: .bottom) {
                                    Text(movie.title)
                                        .font(.title2.bold())
                                    Text("(\(movie.yearString))")
                                    Spacer()
                                    
                                }
                                .frame(height: 30)
                                
                                NavigationLink {
                                    DetailView(vm: DetailView.ViewModel(movie: movie))
                                        .hideTabBar()
                                } label: {
                                    KFImage(URL(string: movie.largeCoverImage ?? ""))
                                        .placeholder {
                                            Rectangle()
                                                .fill(.gray)
                                                .frame(minWidth: 0, maxWidth: .infinity)
                                        }
                                        .resizable()
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .frame(height: 500)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                }
                                HashTagViews(strings: movie.genres)
                                
                                ExpandableText(movie.filteredSummary, lineLimit: 3, font: UIFont.preferredFont(forTextStyle: .caption1))
                            }
                            .padding()
                            .onAppear {
                                vm.showingMovie = movie
                            }
                        }
                        if !vm.isAppended {
                            ProgressView().progressViewStyle(CircularProgressViewStyle())
                        }
                    }
                } else {
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                        .padding(.top, 30)
                }
                
            }
            .onAppear {
                UITabBar.showTabBar()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
