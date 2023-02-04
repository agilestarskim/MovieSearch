//
//  RootView.swift
//  Prography
//
//  Created by 김민성 on 2023/02/04.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
          MainView()
            .tabItem {
              Image(systemName: "house")
              Text("홈")
            }
          SearchView()
            .tabItem {
              Image(systemName: "magnifyingglass")
              Text("검색")
            }
          ProfileView()
            .tabItem {
              Image(systemName: "person")
              Text("프로필")
            }
        }
        .font(.headline)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
