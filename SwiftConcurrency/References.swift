//
//  References.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-04-27.
//

import SwiftUI

final class ReferencesManager {
    func getData() async -> String {
        "Updated data"
    }
}

final class ReferencesViewModel: ObservableObject {
    @Published var data: String = "Some title"
    let manager = ReferencesManager()
    
    private var someTask: Task<Void, Never>? = nil
    private var myTasks: [Task<Void, Never>] = []
    
    func cancelTasks() {
        someTask?.cancel()
        someTask = nil
        
        myTasks.forEach { task in
            task.cancel()
        }
        myTasks = []
    }
    
    //this implies a strong reference
    func updateData() {
        Task {
            data = await manager.getData()
        }
    }
    //this is a strong reference
    func updateData2() {
        Task {
            self.data = await self.manager.getData()
        }
    }
    //this is a strong reference
    func updateData3() {
        Task { [self] in
            self.data = await self.manager.getData()
        }
    }
    
    func updateData4() {
        Task { [weak self] in
            if let data = await self?.manager.getData() {
                self?.data = data
            }
        }
    }
    
    //we don't have to manage weak/strong
    //we can manage the Task
    func updateData5() {
        someTask = Task {
            self.data = await self.manager.getData()
        }
    }
    
    func updateDat6() {
        let task1 = Task {
            self.data = await self.manager.getData()
        }
        
        let task2 = Task {
            self.data = await self.manager.getData()
        }
        
        myTasks.append(contentsOf: [task1, task2])
    }
    
    //We purposely do not cancel tasks to keep strong references
    func updateData7() {
        Task {
            self.data = await self.manager.getData()
        }
        
        Task.detached {
            self.data = await self.manager.getData()
        }
    }
    
}

struct References: View {
    
    @StateObject private var vm = ReferencesViewModel()
    
    
    var body: some View {
        Text(vm.data)
            .onAppear {
                vm.updateData()
            }
            .onDisappear {
                vm.cancelTasks()
            }
    }
}

#Preview {
    References()
}
