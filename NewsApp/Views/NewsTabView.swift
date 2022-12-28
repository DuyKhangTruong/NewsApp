//
//  NewsTabView.swift
//  NewsApp
//
//  Created by Duy Khang Nguyen Truong on 12/20/22.
//

import SwiftUI

struct NewsTabView: View {
    @StateObject var articleNewsVM = ArticleNewsViewModel()
    
    private var articles: [Article] {
        if case let .success(articles) = articleNewsVM.phase {
            return articles
        }
        else {
            return []
        }
    }
    var body: some View {
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .task(id: articleNewsVM.fetchTaskToken, loadTask)
                .refreshable(action: refreshTask)
                .navigationTitle(articleNewsVM.fetchTaskToken.category.text)
                .toolbar {
                    ToolbarItem {
                        menuView
                    }
                }
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch articleNewsVM.phase {
        case .empty:
            ProgressView()
        case .success(articles) where articles.isEmpty: EmptyPlaceholderView(text: "No results found", image: nil)
        case .failure(let error): RetryView(text: error.localizedDescription,retryAction: refreshTask)
        default:
            EmptyView()
        }
    }
    
    private var menuView: some View  {
        Menu {
            Picker("Category", selection: $articleNewsVM.fetchTaskToken.category) {
                ForEach(Category.allCases) {
                    Text($0.text).tag($0)
                }
            }
        } label: {
            Image(systemName: "menubar.rectangle")
                .imageScale(.large)
        }
        
    }
    
    
    private func refreshTask() {
        DispatchQueue.main.async {
            articleNewsVM.fetchTaskToken = FetchTaskToken(category: articleNewsVM.fetchTaskToken.category, token: Date())
        }
        
    }
    
    @Sendable private func loadTask() async {
        await articleNewsVM.loadArticles()
    }
}

struct NewsTabView_Previews: PreviewProvider {
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    static var previews: some View {
        NewsTabView()
            .environmentObject(articleBookmarkVM)
    }
}
