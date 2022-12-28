//
//  NewsAPI.swift
//  NewsApp
//
//  Created by Duy Khang Nguyen Truong on 12/20/22.
//

import Foundation


struct NewsAPI {
    static let shared = NewsAPI()
    private init() {}
    
    private let apikey = ""
    private let session = URLSession.shared
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }()
    
    func fetch(from category: Category) async throws -> [Article]{
        try await fetchNews(from: getURL(from: category))
    }
    
    func search(for query: String) async throws -> [Article] {
        try await fetchNews(from: getSearchURL(from: query))
    }
    
    private func fetchNews(from url: URL) async throws -> [Article] {
        let (data, response) = try await session.data(from: url)
        guard let response = response as? HTTPURLResponse else {
            throw showError(description: "Bad Response")
        }
        switch response.statusCode {
        case (200...299),(400...409):
            let apiResponse = try jsonDecoder.decode(NewsAPIResponse.self, from: data)
            
            if apiResponse.status == "ok" {
                return apiResponse.articles ?? []
            }
            else {
                throw showError(description: apiResponse.message ?? "ERROR!")
            }
        default:
            throw showError(description: "ERROR!")
        }
    }
    
    private func showError(code:Int = 1,description: String) -> Error {
        NSError(domain: "NewsAPI", code: code,userInfo: [NSLocalizedDescriptionKey:description])
    }
    
    private func getSearchURL(from query: String) -> URL {
        let precentEncodedString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        var url = "https://newsapi.org/v2/everything?"
        url += "q=\(precentEncodedString)&"
        url += "language=en&"
        url += "apiKey=\(apikey)"
        print(url)
        return URL(string: url)!
    }
    
    private func getURL(from category: Category) -> URL {
        var url = "https://newsapi.org/v2/top-headlines?"
        url += "language=en&"
        url += "category=\(category.rawValue)&"
        url += "apiKey=\(apikey)"
        print(url)
        return URL(string: url)!
        
    }
}
