//
//  Tasks.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-04-22.
//

import SwiftUI

final class TasksViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        do {
            guard let url = URL(string: "https://picsum.photos/200/300") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image = UIImage(data: data)
                print("image returned")
            }
           
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/500/500") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            
            self.image2 = UIImage(data: data)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink {
                    Tasks()
                } label: {
                    Text("CLick me")
                }

            }
        }
    }
}

struct Tasks: View {
    
    @StateObject private var vm = TasksViewModel()
    @State private var task: Task<(), Never>? = nil
    
    var body: some View {
        VStack {
            if let image = vm.image {
                Image(uiImage: image)
            }
            if let image = vm.image2 {
                Image(uiImage: image)
            }
        }
        .task {
            await vm.fetchImage()
        }
//        .onDisappear {
//            self.task?.cancel()
//        }
//        .onAppear {
//            self.task = Task {
//                await vm.fetchImage()
//            }
//            await vm.fetchImage2()
            
//            Task(priority: .low) {
//                try? await Task.sleep(nanoseconds: 2_000_000_000)
//                print("LOW : \(Thread.current) : \(Task.currentPriority)")
//            }
//            
//            Task(priority: .medium) {
//                print("medium : \(Thread.current) : \(Task.currentPriority)")
//            }
//            
//            Task(priority: .high) {
//                await Task.yield()
//                print("high : \(Thread.current) : \(Task.currentPriority)")
//            }
//            
//            Task(priority: .background) {
//                print("background : \(Thread.current) : \(Task.currentPriority)")
//            }
//            
//            Task(priority: .utility) {
//                print("utility : \(Thread.current) : \(Task.currentPriority)")
//            }
//            
//            Task(priority: .userInitiated) {
//                print("userInitiated : \(Thread.current) : \(Task.currentPriority)")
//            }
            
//            Task(priority: .userInitiated) {
//                print("userInitiated : \(Task.currentPriority)")
//                
//                Task {
//                    print("userInitiated2 : \(Task.currentPriority)")
//                }
//            }
       // }
    }
}

#Preview {
    HomeView()
}
