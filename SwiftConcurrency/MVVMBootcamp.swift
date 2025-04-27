//
//  MVVMBootcamp.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-04-27.
//

import SwiftUI

final class MyManager {
    
    func getData() async throws -> String {
        "Some data"
    }
    
}

actor MyActorManager {
    func getData() async throws -> String {
        "Some data"
    }
}

@MainActor
final class MVVMBootCampViewModel: ObservableObject {
    
    let manager = MyManager()
    let actor = MyActorManager()
    
    private var callTasks: [Task<Void, Never>] = []
    @Published private(set) var myData: String = "Starting text"
    
    func cancelTasks() {
        callTasks.forEach({ $0.cancel() })
    }
    
    func buttonPressed() {
        let task = Task {
            do {
                myData = try await manager.getData()
            } catch {
                print(error)
            }
        }
        callTasks.append(task)
    }
    
}

struct MVVMBootcamp: View {
    
    @StateObject private var vm = MVVMBootCampViewModel()
    
    var body: some View {
        VStack {
            Text(vm.myData)
                .font(.headline)
            
            Button("Click Me") {
                vm.buttonPressed()
            }
            
        }
        .onDisappear {
            vm.cancelTasks()
        }
    }
}

#Preview {
    MVVMBootcamp()
}
