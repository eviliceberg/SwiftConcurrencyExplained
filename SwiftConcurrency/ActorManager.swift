//
//  ActorManager.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-05-13.
//

import SwiftUI

actor MyActorNetworkManager {
    
    let url = "https://dummyjson.com/image/150"
    var someString: String = ""
    var newValue1: String {
        get {
            url
        }
        set {
            someString = newValue
        }
    }
    
    func fetchImage() async throws -> Data {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let resp = response as? HTTPURLResponse, resp.statusCode == 200 else { throw URLError(.badServerResponse) }
        
        return data
    }
    
    func returnString() -> String {
        return url
    }
    
    func updateText(text: String) {
        someString = text
    }
}

@Observable
@MainActor
final class ActorViewModel {
    
    let manager = MyActorNetworkManager()
    
    var helloText: String? = nil
    var imageData: Data?
    var data: String?
    
    func getData() async throws {
        imageData = try await manager.fetchImage()
        
    }
    
}

struct ActorManager: View {
    
    @State private var vm = ActorViewModel()
    
    var body: some View {
        VStack(spacing: 50) {
            ZStack {
                if let data = vm.imageData, let newImage = UIImage(data: data) {
                    Image(uiImage: newImage)
                } else {
                    ProgressView()
                }
            }
            .frame(width: 100, height: 100)
            .clipShape(.circle)
            .shadow(color: .black, radius: 2)
            
            Text(vm.manager.url)
                .font(.title)
                .fontWeight(.bold)
        }
        .task {
            do {
                try await vm.getData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ActorManager()
}
