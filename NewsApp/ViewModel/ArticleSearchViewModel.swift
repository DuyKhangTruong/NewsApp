//
//  ArticleSearchViewModel.swift
//  NewsApp
//
//  Created by Duy Khang Nguyen Truong on 12/24/22.
//

import SwiftUI

@MainActor
class ArticleSearchViewModel: ObservableObject {
    @Published var phase: DataFetchPhrase<[Article]> = .empty
    @Published var searchQuery: String = ""
    @Published var historySearch = [String]()
    
    private var historyDataStore = PlistDataStore<[String]>(fileName: "histories")
    
    private let historyLimit = 10
    
    private let newsAPI = NewsAPI.shared
    static let shared = ArticleSearchViewModel()
    
    private init() {
        loadData()
    }
    
    func addHistory(_ text: String) {
        if let index = historySearch.firstIndex(where: { text.lowercased() == $0.lowercased()}) {
            historySearch.remove(at: index)
        } else if historySearch.count == historyLimit {
            historySearch.remove(at: historySearch.count - 1)
        }
        
        historySearch.insert(text, at: 0)
        updateHistories()
    }
    
    func removeHistory(_ text: String) {
        guard let index = historySearch.firstIndex(where: {text.lowercased() == $0.lowercased()}) else { return }
        historySearch.remove(at: index)
        updateHistories()
    }
    
    func removeAllHistory() {
        historySearch.removeAll()
        updateHistories()
    }
    
    func searchArticles() async {
        let searchQuery = self.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        phase = .empty
        
        if searchQuery.isEmpty {
            return
        }
        
        do {
            let articles = try await newsAPI.search(for: searchQuery)
            if Task.isCancelled { return }
            phase = .success(articles)
            if searchQuery != self.searchQuery {
                return
            }
        } catch {
            if Task.isCancelled { return }
            if searchQuery != self.searchQuery {
                return
            }
            print(error.localizedDescription)
            phase = .failure(error)
        }
        
    }
    
    private func loadData() {
        async {
            self.historySearch = await historyDataStore.load() ?? []
        }
    }
    
    private func updateHistories() {
        let historySearch = self.historySearch
        async {
            await historyDataStore.save(historySearch)
        }
    }
}

