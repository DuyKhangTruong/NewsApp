//
//  Category.swift
//  NewsApp
//
//  Created by Duy Khang Nguyen Truong on 12/20/22.
//

import Foundation

enum Category: String, CaseIterable {
    case general, business, technology, entertainment, sports, science, health
    
    var text: String {
        if self == .general {
            return "Top Headlines"
        }
        return rawValue.capitalized
        
    }
}

extension Category: Identifiable {
    var id: Self {self}
}
