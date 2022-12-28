//
//  ArticleNewsViewModel.swift
//  NewsApp
//
//  Created by Duy Khang Nguyen Truong on 12/20/22.
//

import SwiftUI

enum DataFetchPhrase<T> {
    case empty
    case success(T)
    case failure(Error)
}

struct FetchTaskToken: Equatable {
    var category: Category
    var token: Date
}

@MainActor
class ArticleNewsViewModel: ObservableObject {
    @Published var phase = DataFetchPhrase<[Article]>.empty
    @Published var fetchTaskToken: FetchTaskToken
    private let newsAPI = NewsAPI.shared
    
    init(articles:[Article]? = nil, selectedCategory: Category = .general) {
        if let articles = articles {
            self.phase = .success(articles)
        }
        else {
            self.phase = .empty
        }
        self.fetchTaskToken = FetchTaskToken(category: selectedCategory, token: Date())
    }
    
    func loadArticles() async {
        if Task.isCancelled { return }
        phase = .empty
        do {
            let articles = try await newsAPI.fetch(from: fetchTaskToken.category)
            if Task.isCancelled { return }
            phase = .success(articles)
        } catch {
            if Task.isCancelled { return }
            print(error.localizedDescription)
            phase = .failure(error)
        }
    }
}
