//
//  ContentView.swift
//  NewsApp
//
//  Created by Duy Khang Nguyen Truong on 12/19/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NewsTabView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            SearchTabView()
                .tabItem {
                    Label("Search",systemImage: "magnifyingglass")
                }
            BookmarkTabView()
                .tabItem {
                    Label("Bookmarks",systemImage: "bookmark")
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    static var previews: some View {
        ContentView()
            .environmentObject(articleBookmarkVM)
    }
}
