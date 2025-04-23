//
//  Countinuation.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-04-23.
//

import SwiftUI

class NetworkManager {
    func getData(url: URL) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badServerResponse))
                }
            }
            .resume()
        }
    }
    
    func getHeartImageDatabase(completion: @escaping (_ image: UIImage) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(UIImage(systemName: "heart.fill")!)
        }
    }
    
    func getHeartImageDatabaseAsync() async -> UIImage {
        await withCheckedContinuation { continuation in
            getHeartImageDatabase { image in
                continuation.resume(returning: image)
            }
        }
    }
    
}

final class ContinuationViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let url = URL(string: "https://picsum.photos/200/300")!
    let manager = NetworkManager()
    
    func getImage() async {
        do {
            self.image = UIImage(data: try await manager.getData(url: url))
        } catch {
            print(error)
        }
    }
    
    func getHeartImage() async {
        self.image = await manager.getHeartImageDatabaseAsync()
    }
    
}

struct Continuation: View {
    
    @StateObject private var vm = ContinuationViewModel()
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
            }
        }
        .task {
            await vm.getHeartImage()
        }
    }
}

#Preview {
    Continuation()
}
