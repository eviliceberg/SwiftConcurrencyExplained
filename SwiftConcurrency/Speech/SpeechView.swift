//
//  SpeechView.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-05-18.
//

import SwiftUI
import WebKit

struct GifView: UIViewRepresentable {
    
    private let name: String
    private let color: Color
    
    init(name: String, background: Color = .white) {
        self.name = name
        self.color = background
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        do {
            guard let url = Bundle.main.url(forResource: name, withExtension: "gif") else { throw URLError(.badURL) }
            let data = try Data(contentsOf: url)
            
            webView.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
            
            webView.scrollView.isScrollEnabled = false
            webView.isOpaque = false
            webView.backgroundColor = .white
        } catch {
            print(error.localizedDescription)
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
}

struct SpeechView: View {
    @StateObject var recognizer = SpeechRecognizer()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.white, .green.opacity(0.35)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Button("🎤 Почати запис") {
                    recognizer.checkSpeechPermission { granted in
                        if granted {
                            recognizer.requestAuthorization()
                            recognizer.startTranscribing()
                        }
                    }
                    
                }
                
                Button("⏹ Зупинити запис") {
                    recognizer.stopTranscribing()
                    print(recognizer.recognizedText)
                }
                VStack {
                    GifView(name: "gif")
                        .frame(width: 176, height: 178)
                        .shadow(radius: 6)
                        .overlay(alignment: .bottom) {
                            Text("Recording...")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                                .padding(.bottom, 10)
                        }
                    
                }
                .padding()
                .background(.white)
                .clipShape(.rect(cornerRadius: 10))
                
            }
            .onAppear(perform: {
                
            })
            .padding()
            .alert("To use app give recording permission", isPresented: $recognizer.showSettingsAlert) {
                Button("Cancel") { }
                
                Button {
                    recognizer.openSettings()
                } label: {
                    Text("Settings")
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    SpeechView()
}
