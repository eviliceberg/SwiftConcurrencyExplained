//
//  AsyncLet.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-04-23.
//

import SwiftUI

struct AsyncLet: View {
    
    @State private var images: [UIImage] = []
    let url = URL(string: "https://picsum.photos/200/300")!
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    ForEach(images, id: \.self) { image in
                            Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                        
                    }
                }
            }
            .navigationTitle("Async Let")
            .onAppear {
                Task {
                    do {
                        async let image = fetchImage()
                        self.images.append(try await image)
                        
                        async let image1 = fetchImage()
                        self.images.append(try await image1)
                        
                        async let image2 = fetchImage()
                        self.images.append(try await image2)
                        
                        async let image3 = fetchImage()
                        self.images.append(try await image3)
                    } catch {
                        print(error)
                    }                }
            }
        }
    }
    
    func fetchImage() async throws -> UIImage {
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

#Preview {
    AsyncLet()
}
