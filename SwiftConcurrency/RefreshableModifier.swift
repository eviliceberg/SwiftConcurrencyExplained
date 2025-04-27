//
//  RefreshableModifier.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-04-27.
//

import SwiftUI

final class RefreshableDataManager {
    
    func getData() async throws -> [String] {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"].shuffled()
    }
    
}

@MainActor
final class RefreshableModifierViewModel: ObservableObject {
    @Published private(set) var items: [String] = []
    let manager = RefreshableDataManager()
    
    func loadData() async {
        do {
            self.items = try await manager.getData()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct RefreshableModifier: View {
    
    @StateObject var vm = RefreshableModifierViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(vm.items, id: \.self) { item in
                        Text(item)
                            .font(.headline)
                    }
                }
            }
            .refreshable {
                await vm.loadData()
            }
            .task {
                await vm.loadData()
            }
            .navigationTitle("Refreshable")
        }
        
    }
}

#Preview {
    RefreshableModifier()
}
