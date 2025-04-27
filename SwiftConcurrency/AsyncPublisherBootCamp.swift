//
//  AsyncPublisherBootCamp.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-04-27.
//

import SwiftUI
import Combine

actor AsyncPublisherDataManager {
    
    @Published var data: [String] = []
    
    func addData() async {
        data.append("Apple")
        data.append("Apple1")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        data.append("Apple2")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        data.append("Apple3")
        data.append("Apple4")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        data.append("Apple5")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        data.append("Apple6")
    }
}

@MainActor
class AsyncPublisherViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    let manager = AsyncPublisherDataManager()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
//        await manager.$data
//            .sink { array in
//                self.dataArray = array
//            }
//            .store(in: &cancellables)
        Task {
            for await value in await manager.$data.values {
                self.dataArray = value
               // break
            }
        }
        Task {
            self.dataArray.append("One")
        }
        
        
        
    }
    
    func start() async {
        await manager.addData()
    }
}

struct AsyncPublisherBootCamp: View {
    
    @StateObject private var vm = AsyncPublisherViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.dataArray, id: \.self) { item in
                    Text(item)
                        .font(.headline)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .animation(.smooth, value: vm.dataArray)
        .task {
            await vm.start()
        }
    }
}

#Preview {
    AsyncPublisherBootCamp()
}
