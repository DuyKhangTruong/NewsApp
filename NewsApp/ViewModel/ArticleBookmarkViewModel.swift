//
//  ArticleBookmarkViewModel.swift
//  NewsApp
//
//  Created by Duy Khang Nguyen Truong on 12/22/22.
//

import SwiftUI

@MainActor
class ArticleBookmarkViewModel: ObservableObject {
    @Published private(set) var bookmarks: [Article] = []
    private let bookmarkStore = PlistDataStore<[Article]>(fileName: "bookmarks")
    
    static let shared = ArticleBookmarkViewModel()
    
    private init() {
        async {
            await loadData()
        }
    }
    
    private func loadData() async {
        bookmarks = await bookmarkStore.load() ?? []
    }
    
    func isBookmarked(for article: Article) -> Bool {
        bookmarks.first { article.id == $0.id} != nil
    }
    
    func addBookmark(for article: Article) {
        guard !isBookmarked(for: article) else {
            return
        }
        
        bookmarks.insert(article, at: 0)
        updateBookmarks()
    }
    
    func removeBookmark(for article: Article) {
        guard let index = bookmarks.firstIndex(where: {$0.id == article.id}) else {return}
        bookmarks.remove(at: index)
        updateBookmarks()
    }
    
    private func updateBookmarks() {
        let bookmarks = self.bookmarks
        async {
            await bookmarkStore.save(bookmarks)
        }
    }
}
