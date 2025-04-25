//
//  Async:Await.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-04-22.
//

import SwiftUI

final class Async_AwaitViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataArray.append("Title 1: \(Thread.current)")
        }
    }
    
    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title = "Title 1: \(Thread.current)"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.dataArray.append(title)
            }
        }
    }
    
    func addAuthor1() async {
        let author1 = "au1"
        self.dataArray.append(author1)
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let author2 = "au2"
        self.dataArray.append(author2)
        
        await addSomething()
    }
    
    func addSomething() async {
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let author2 = "au2: "
        await MainActor.run {
            self.dataArray.append(author2)
            
            let author3 = "au3: \(Thread.current)"
            self.dataArray.append(author3)
        }
       
        
    }
}

struct Async_Await: View {
    
    @StateObject private var vm = Async_AwaitViewModel()
    
    var body: some View {
        List {
            ForEach(vm.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .onAppear {
            Task {
                await vm.addAuthor1()
            }
        }
    }
}

#Preview {
    Async_Await()
}
