//
//  TaskGroup.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-04-23.
//

import SwiftUI

class DataManager {
    let url = ["https://picsum.photos/200",
               "https://picsum.photos/200",
               "https://picsum.photos/200",
               "https://picsum.photos/200",
               "https://picsum.photos/200",
               "https://picsum.photos/200",
               "https://picsum.photos/200"]
    func fetchImagesAsyncLet() async -> [UIImage] {
        do {
            async let image = fetchImage(urlString: url[0])
            async let image1 = fetchImage(urlString: url[0])
            async let image2 = fetchImage(urlString: url[0])
            async let image3 = fetchImage(urlString: url[0])
            async let image4 = fetchImage(urlString: url[0])
            async let image5 = fetchImage(urlString: url[0])
            
            return await [try image, try image1, try image2, try image3, try image4, try image5]
        } catch {
            print(error)
            return []
        }
    }
    
    func fetchImagesTaskGroup() async throws -> [UIImage] {
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images: [UIImage] = []
            images.reserveCapacity(url.count)
            for urlString in url {
                group.addTask {
                    try? await self.fetchImage(urlString: urlString)
                }
            }
            
            for try await result in group {
                if let result = result {
                    images.append(result)
                }
            }
            
            return images
        }
    }
    
    private func fetchImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}

final class TaskGroupViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    let manager = DataManager()
    
    func getImages() async {
        self.images.append(contentsOf: await manager.fetchImagesAsyncLet())
    }
}

struct TaskGroup: View {
    
    @StateObject private var vm = TaskGroupViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    ForEach(vm.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Task Group")
            .task {
                await vm.getImages()
            }
        }
    }
}

#Preview {
    TaskGroup()
}
