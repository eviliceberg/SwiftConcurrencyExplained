//
//  Actors.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-04-26.
//

import SwiftUI
import Combine

class MyDataManager {
    
    static let shared = MyDataManager()
    private init() { }
    
    var data: [String] = []
    private let queue = DispatchQueue(label: "com.MyApp.MyDataManager")
    
    func getData(completion: @escaping (_ title: String?) -> Void) {
        
        queue.async {
            self.data.append(UUID().uuidString)
            
            completion(self.data.randomElement())
        }
    }
}

actor MyActorDataManager {
    
    static let shared = MyActorDataManager()
    private init() { }
    
    var data: [String] = []
    
    func getData() -> String? {
        
        self.data.append(UUID().uuidString)
        
        return data.randomElement()
    }
}

struct HomeActorView: View {
    
    let manager = MyActorDataManager.shared
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.5).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
//            manager.getData { title in
//                if let data = title {
//                    DispatchQueue.main.async {
//                        self.text = data
//                    }
//                }
//            }
            
            Task {
                if let data = await manager.getData() {
                    text = data
                }
            }
        }
    }
}

struct BrowseView: View {
    
    let manager = MyActorDataManager.shared
    @State private var text: String = ""
    @State private var text2: String = ""
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    let timer2 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.5).ignoresSafeArea()
            VStack {
                Text(text)
                    .font(.headline)
                
                Text(text2)
                    .font(.headline)
            }
        }
        .onReceive(timer) { _ in
            Task {
                if let data = await manager.getData() {
                    text = data
                }
            }
//            manager.getData { title in
//                if let data = title {
//                    DispatchQueue.main.async {
//                        self.text = data
//                    }
//                }
//            }
        }
        .onReceive(timer2) { output in
            text2 = output.description
        }
        
    }
}


struct Actors: View {
    var body: some View {
        TabView {
            Tab("Hello", systemImage: "heart.fill") {
                HomeActorView()
            }
            Tab("World", systemImage: "globe") {
                BrowseView()
            }
            
        }
    }
}

#Preview {
    Actors()
}
