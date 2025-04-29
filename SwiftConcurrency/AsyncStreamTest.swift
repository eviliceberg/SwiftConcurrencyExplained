//
//  AsyncStreamTest.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-04-29.
//

import SwiftUI

class AsyncStreamDataManager {
    
    func getAsyncStream() -> AsyncThrowingStream<Int, Error> {
        AsyncThrowingStream { [weak self] continuation in
            self?.getData { value in
                continuation.yield(value)
            } onFinish: { error in
                continuation.finish(throwing: error)
            }
        }
    }
    
    func getData(completion: @escaping (_ value: Int) -> Void, onFinish: @escaping (_ error: Error?) -> Void) {
        let items: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        
        for item in items {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(item)) {
                completion(item)
                print("new value: \(item)")
                
                if item == items.last {
                    onFinish(nil)
                }
            }
        }
    }
    
    
}

@MainActor
final class AsyncStreamViewModel: ObservableObject {
    
    let manager = AsyncStreamDataManager()
    @Published private(set) var currentNumber: Int = 0
    
    func onViewAppear() {
//        manager.getData { [weak self] value in
//            self?.currentNumber = value
//        }
        Task {
            do {
                for try await value in manager.getAsyncStream().dropFirst(2) {
                    self.currentNumber = value
                }
            } catch {
                print(error)
            }
        }
    }
    
}

struct AsyncStreamTest: View {
    
    @StateObject private var vm = AsyncStreamViewModel()
    
    var body: some View {
        Text("\(vm.currentNumber)")
            .onAppear {
                vm.onViewAppear()
            }
    }
}

#Preview {
    AsyncStreamTest()
}
