//
//  NewsAPIResponse.swift
//  NewsApp
//
//  Created by Duy Khang Nguyen Truong on 12/19/22.
//

import Foundation

struct NewsAPIResponse: Decodable {
    let status: String
    let totalResults: Int?
    let articles: [Article]?
    
    let code: String?
    let message: String?
}
