//
//  PrographyApp.swift
//  Prography
//
//  Created by 김민성 on 2023/02/04.
//

import SwiftUI

@main
struct MovieSearchApp: App {
    @ObservedObject private var user = User()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(user)
        }
    }
}
