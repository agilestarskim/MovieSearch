//
//  ProfileView.swift
//  Prography
//
//  Created by 김민성 on 2023/02/04.
//

import SwiftUI
import Kingfisher
import HidableTabView

struct ProfileView: View {
    @EnvironmentObject var user: User
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ZStack {
                        Rectangle()
                            .fill(.blue)
                            .frame(height: 250)
                            
                        Image("profile")
                            .resizable()
                            .background(Circle().fill(.regularMaterial))
                            .frame(width: 200, height: 200)
                            .offset(CGSize(width: 0, height: 80))
                    }
                    VStack {
                        HStack {
                            Text("북마크")
                                .font(.title2.bold())
                            Image(systemName: "bookmark.fill")
                                .foregroundColor(.orange)
                            Spacer()
                        }
                        .padding()
                        LazyVGrid(columns: [.init(.adaptive(minimum: 120, maximum: .infinity), spacing: 3)], spacing: 3) {
                            ForEach(user.bookmarkedMovies, id: \.id) { movie in
                                NavigationLink {
                                    DetailView(vm: DetailView.ViewModel(movie: movie))
                                } label: {
                                    KFImage(URL(string: movie.mediumCoverImage ?? ""))
                                        .placeholder {
                                            Rectangle()
                                                .fill(.gray)
                                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                        }
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                        .clipped()
                                        .aspectRatio(1, contentMode: .fit)
                                }
                            }
                        }
                        
                        
                    }
                    .padding(.top, 50)
                }
            }
            .onAppear {
                UITabBar.showTabBar()
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(User())
    }
}
