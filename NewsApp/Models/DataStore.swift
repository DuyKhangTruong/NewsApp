//
//  DataStore.swift
//  NewsApp
//
//  Created by Duy Khang Nguyen Truong on 12/23/22.
//

import Foundation

protocol DataStore: Actor {
    associatedtype D
    
    func save(_ current: D)
    func load() -> D?
    
}

actor PlistDataStore<T: Codable>:DataStore where T: Equatable {
    var saved: T?
    let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    private var dataURL: URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathExtension("\(fileName).plist")
    }
    
    func save(_ current: T) {
        if let saved = self.saved, saved == current {
            return
        }
        do {
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .binary
            let data = try encoder.encode(current)
            try data.write(to: dataURL,options: [.atomic])
            self.saved = current
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load() -> T? {
        do {
            let data = try Data(contentsOf: dataURL)
            let decoder = PropertyListDecoder()
            let current = try decoder.decode(T.self, from: data)
            self.saved = current
            return current
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
