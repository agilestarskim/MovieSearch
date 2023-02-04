//
//  SearchView.swift
//  Prography
//
//  Created by 김민성 on 2023/02/04.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            VStack{
                
            }
            .navigationTitle("영화검색")
        }
        .searchable(text: $searchText)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
