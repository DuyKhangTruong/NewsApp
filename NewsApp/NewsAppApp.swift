//
//  NewsAppApp.swift
//  NewsApp
//
//  Created by Duy Khang Nguyen Truong on 12/19/22.
//

import SwiftUI

@main
struct NewsAppApp: App {
    @StateObject var articleBookmarkVM = ArticleBookmarkViewModel.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(articleBookmarkVM)
        }
    }
}
