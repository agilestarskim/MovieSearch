//
//  DetailView.swift
//  Prography
//
//  Created by 김민성 on 2023/02/04.
//

import SwiftUI
import Kingfisher
import Alamofire
import Combine
import HidableTabView

struct DetailView: View {
    @EnvironmentObject var user: User
    @ObservedObject var vm: ViewModel
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                
                VStack{
                    KFImage(URL(string: vm.movie.largeCoverImage ?? ""))
                        .placeholder {
                            Rectangle()
                                .fill(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity)
                        }
                        .resizable()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .blur(radius: 20)
                        .contrast(0.5)
                        .brightness(0.1)
                    Spacer()
                }
                .ignoresSafeArea(.all)
                
                ScrollView {
                    KFImage(URL(string: vm.movie.largeCoverImage ?? ""))
                        .placeholder {
                            Rectangle()
                                .fill(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity)
                        }
                        .resizable()
                        .frame(width: geo.size.width - 30, height: geo.size.height - 300)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                                                            
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Button {
                                    //좋아요 되어있으면 제거하고 버튼 모양 바꾸기
                                    if user.isLike(selectedMovieId: vm.movie.id) {
                                        guard let index = user.likeMovieIds.firstIndex(of: vm.movie.id) else { return }
                                        user.likeMovieIds.remove(at: index)
                                    }
                                    //좋아요 되어있지 않으면 추가하고 버튼 모양바꾸기
                                    else {
                                        user.likeMovieIds.append(vm.movie.id)
                                    }
                                } label: {
                                    Image(systemName: user.isLike(selectedMovieId: vm.movie.id) ? "heart.fill" : "heart")
                                        .foregroundColor(.red)
                                        .fontWeight(.semibold)
                                        .font(.title2)
                                }
                                
                                Button {
                                    vm.showingAlert = true
                                } label: {
                                    Image(systemName: "message")
                                        .foregroundColor(.primary)
                                        .fontWeight(.semibold)
                                        .font(.title2)
                                }
                                .alert("서비스 준비 중입니다.", isPresented: $vm.showingAlert) {
                                    Button("확인"){}
                                }
                                
                                Button {
                                    
                                } label: {
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.primary)
                                        .fontWeight(.semibold)
                                        .font(.title2)
                                }
                                
                                Spacer()
                                
                                Button {
                                    //북마크 되어있으면 제거하고 버튼 모양 바꾸기
                                    if user.isBookmarked(selectedMovie: vm.movie) {
                                        guard let index = user.bookmarkedMovies.firstIndex(of: vm.movie) else { return }
                                        user.bookmarkedMovies.remove(at: index)
                                    }
                                    //북마크 되어있지 않으면 추가하고 버튼 모양바꾸기
                                    else {
                                        user.bookmarkedMovies.append(vm.movie)
                                    }
                                    
                                } label: {
                                    Image(systemName: user.isBookmarked(selectedMovie: vm.movie) ? "bookmark.fill" : "bookmark")
                                        .foregroundColor(.orange)
                                        .fontWeight(.semibold)
                                        .font(.title2)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(vm.movie.title)
                                    .font(.largeTitle.bold())
                                Text("\(vm.movie.yearString)년 개봉")
                                    .bold()
                                Text("\(vm.movie.likeCount ?? 0) 명이 좋아합니다.")
                                    .bold()
                                
                                Text("\(vm.movie.downloadCount ?? 0) 명이 다운로드 했습니다.")
                                    .bold()
                            }
                            
                            
                            Text(vm.movie.descriptionIntro ?? "")
                                .font(.caption)
                                .lineLimit(vm.seeMore ? nil : 5)
                            Button(vm.seeMore ? "숨기기" : "더보기") {
                                vm.seeMore.toggle()
                            }                            
                            
                            Text("비슷한 영화 추천")
                                .font(.title2.bold())
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(vm.suggestionMovies, id: \.id){ movie in
                                        NavigationLink {
                                            DetailView(vm: ViewModel(movie: movie))
                                        } label: {
                                            KFImage(URL(string: movie.mediumCoverImage ?? ""))
                                                .placeholder {
                                                    Rectangle()
                                                        .fill(.gray)
                                                }
                                                .resizable()
                                                .frame(width: 100, height: 150)
                                                .cornerRadius(5)
                                                .shadow(radius: 3)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .frame(width: geo.size.width - 30)
                        .background(.regularMaterial)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .scrollIndicators(.hidden)
            }            
        }
        .onAppear {
            UITabBar.hideTabBar()
            vm.fetchSuggetion(movie: vm.movie)
        }
        
    }
}

struct DetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        DetailView(vm: DetailView.ViewModel(movie: Movie.testData))
            .environmentObject(User())
    }
    
}
