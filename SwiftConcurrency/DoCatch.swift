//
//  DoCatch.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-04-22.
//

import SwiftUI

final class SomeManager {
    
    let isActive: Bool = false
    
    func getTitle() throws -> String {
        guard isActive else { throw URLError(.badURL) }
        return "New TExt"
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("Success")
        } else {
            return .failure(URLError(.badURL))
        }
    }
    
}

final class DoCatchViewModel: ObservableObject {
    
    @Published var text: String = "text"
    
    let manager = SomeManager()
    
    func fetchText() throws {
        let newTitle = try manager.getTitle()
        self.text = newTitle
    }
    
}

struct DoCatch: View {
    
    @StateObject private var vm = DoCatchViewModel()
    
    var body: some View {
        Text(vm.text)
            .frame(width: 300, height: 300)
            .background(.yellow)
            .onTapGesture {
                do {
                    try vm.fetchText()
                } catch {
                    print(error)
                }
            }
    }
}

#Preview {
    DoCatch()
}
