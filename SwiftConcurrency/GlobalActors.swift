//
//  GlobalActors.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-04-26.
//

import SwiftUI

@globalActor struct MyGlobalActor {
    static var shared = MyNewDataManager()
    
}

actor MyNewDataManager {
    
    func getData() -> [String] {
        
        return ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"]
    }
    
}

@MainActor
class GlobalActorsViewModel: ObservableObject {
    @Published var dataArray: [String] = []
    let manager = MyGlobalActor.shared
    
    func getData() {
        Task {
            let data = await manager.getData()
            self.dataArray = data
            
        }
    }
}

struct GlobalActors: View {
    
    @StateObject private var viewModel = GlobalActorsViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) { data in
                        Text(data)
                        .font(.headline)
                }
            }
            .task {
                await viewModel.getData()
            }
        }
    }
}

#Preview {
    GlobalActors()
}
