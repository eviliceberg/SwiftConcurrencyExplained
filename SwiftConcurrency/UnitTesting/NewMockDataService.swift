//
//  NewMockDataService.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-05-08.
//

import Foundation
import Combine
import SwiftUI

protocol NewDataServiceProtocol {
    func downloadItems(completion: @escaping (_ items: [String]) -> Void)
    
    func downloadItemsCombine() -> AnyPublisher<[String], Error>
}

class NewMockDataService: NewDataServiceProtocol {
    
    let items: [String]
    
    init(items: [String]?) {
        self.items = items ?? ["Apple", "Banana", "Orange"]
    }
    
    func downloadItems(completion: @escaping (_ items: [String]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion(self.items)
        }
    }
    
    func downloadItemsCombine() -> AnyPublisher<[String], Error> {
        Just(items)
            .tryMap({ item in
                guard !item.isEmpty else { throw URLError(.badURL) }
                return item
            })
            .eraseToAnyPublisher()
    }
    
}
