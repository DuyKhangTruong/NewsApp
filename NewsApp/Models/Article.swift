//
//  Article.swift
//  NewsApp
//
//  Created by Duy Khang Nguyen Truong on 12/19/22.
//

import Foundation

fileprivate let relativeDateFormatter = RelativeDateTimeFormatter()

struct Article {
    let source: Source
    let title: String
    let description: String
    let url: String
    let publishedAt: Date
    
    //Optional variables
    let urlToImage: String?
    let author: String?
    
    
//    var descriptionText: String {
//        description ?? ""
//    }
//
    
    var authorText: String {
        author ?? ""
    }
    
    var captionText: String {
        "\(source.name) . \(relativeDateFormatter.localizedString(for: publishedAt, relativeTo: Date()))"
    }

    var articleURL: URL {
        URL(string: url)!
    }

    var urlImageText: URL? {
        guard let urlToImage = urlToImage else {
            return nil
        }

        return URL(string: urlToImage)
    }
    
}

extension Article: Codable {}
extension Article: Equatable {}
extension Article: Identifiable {
    var id: String { url }
}

extension Article {
    static var previewData: [Article] {
        let previewURL = Bundle.main.url(forResource: "exampleNews", withExtension: "json")!
        let data = try! Data(contentsOf: previewURL)
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        let apiResponse = try! jsonDecoder.decode(NewsAPIResponse.self, from: data)
        
        return apiResponse.articles ?? []
    }
}

struct Source {
    let name: String
}

extension Source: Codable {}
extension Source: Equatable {}
