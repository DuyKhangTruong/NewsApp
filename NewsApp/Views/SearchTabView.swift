//
//  SearchTabView.swift
//  NewsApp
//
//  Created by Duy Khang Nguyen Truong on 12/24/22.
//

import SwiftUI

struct SearchTabView: View {
    @StateObject var searchVM = ArticleSearchViewModel.shared
    
    var body: some View {
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .navigationTitle("Search")
        }
        .searchable(text: $searchVM.searchQuery) {suggestionView}
        .onChange(of: searchVM.searchQuery, perform: { newValue in
            if newValue.isEmpty {
                searchVM.phase = .empty
            }
        })
        .onSubmit(of: .search, search)
    }
    
    private var articles: [Article] {
        if case .success(let articles) = searchVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch searchVM.phase {
        case .empty:
            if !searchVM.searchQuery.isEmpty {
                ProgressView()
            }
            else if !searchVM.historySearch.isEmpty {
                SearchHistoryListView(searchVM: searchVM) { newValue in
                    searchVM.searchQuery = newValue
                    search()
                }
                
            }
            else {
                EmptyPlaceholderView(text: "Please type keywords you want to search", image: Image(systemName: "magnifyingglass"))
            }
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No articles found", image: Image(systemName: "magnifyingglass"))
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: search)
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var suggestionView: some View {
        ForEach(["Apple","Messi","World Cup"], id: \.self) { keyword in
            Button {
                searchVM.searchQuery = keyword
            } label: {
                Text(keyword)
            }
            
        }
    }
    
    private func search() {
        let searchQuery = searchVM.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if !searchQuery.isEmpty {
            searchVM.addHistory(searchQuery)
        }
        async {
            await searchVM.searchArticles()
        }
    }
}

struct SearchTabView_Previews: PreviewProvider {
    @StateObject static var bookmarkVM = ArticleBookmarkViewModel.shared
    static var previews: some View {
        SearchTabView()
            .environmentObject(bookmarkVM)
    }
}
