//
//  UnitTestingBootcampViewModel.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-05-07.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class UnitTestingBootcampViewModel: ObservableObject {
    @Published var isPremium: Bool
    @Published var dataArray: [String] = []
    @Published var selectedItem: String? = nil
    
    let manager: NewDataServiceProtocol
    var cancellables: Set<AnyCancellable> = []
    
    init(isPremium: Bool, manager: NewDataServiceProtocol = NewMockDataService(items: nil)) {
        self.isPremium = isPremium
        self.manager = manager
    }
    
    func selectItem(item: String) {
        if let x = dataArray.first(where: { $0 == item }) {
            selectedItem = x
        } else {
            selectedItem = nil
        }
    }
    
    func addItem(item: String) {
        guard !item.isEmpty else { return }
        
        self.dataArray.append(item)
    }
    
    func saveItem(item: String) throws {
        guard !item.isEmpty else { throw DataError.noData }
        
        if let x = dataArray.first(where: { $0 == item }) {
            print("Save item here! \(x)")
        } else {
            throw DataError.itemNotFound
        }
    }
    
    func downloadEscaping() {
        manager.downloadItems { [weak self] items in
            self?.dataArray = items
        }
    }
    
    func downloadCombine() {
        manager.downloadItemsCombine()
            .sink { _ in
                
            } receiveValue: { [weak self] items in
                self?.dataArray = items
            }
            .store(in: &cancellables)
    }
    
}

enum DataError: Error {
    case noData
    case itemNotFound
}
