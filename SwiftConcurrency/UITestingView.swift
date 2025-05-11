//
//  UITestingView.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-05-11.
//

import SwiftUI

@MainActor
final class UITestingViewModel: ObservableObject {
    
    @Published var text: String = ""
    let placeholder: String = "Hello, World!"
    @Published var userIsSignedIn: Bool
    
    init(userIsSignedIn: Bool) {
        self.userIsSignedIn = userIsSignedIn
    }
    
    func signUpPressed() {
        guard !text.isEmpty else { return }
        userIsSignedIn = true
        
    }
    
}

struct UITestingView: View {
    
    @StateObject private var vm: UITestingViewModel
    
    init(userIsSignedIn: Bool) {
        _vm = StateObject(wrappedValue: UITestingViewModel(userIsSignedIn: userIsSignedIn))
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            
            ZStack {
                if vm.userIsSignedIn {
                    SignedInHomeView()
                } else {
                    sigbUpLayer
                        .transition(.move(edge: .leading))
                }
            }
            
        }
    }
}

#Preview {
    UITestingView(userIsSignedIn: false)
}

extension UITestingView {
    
    private var sigbUpLayer: some View {
        VStack {
            TextField(vm.placeholder, text: $vm.text)
                .font(.headline)
                .padding()
                .background(.white)
                .clipShape(.rect(cornerRadius: 10))
                .accessibilityIdentifier("Sign Up TextField")
            
            Button {
                withAnimation(.spring) {
                    vm.signUpPressed()
                }
            } label: {
                Text("Sign Up")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .clipShape(.rect(cornerRadius: 10))
                    .accessibilityIdentifier("SignUpButton")
            }
        }
        .padding()
    }
}

struct SignedInHomeView: View {
    
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Button {
                    showAlert.toggle()
                } label: {
                    Text("Show welcome alert")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.red)
                        .clipShape(.rect(cornerRadius: 10))
                }
                .accessibilityIdentifier("ShowAlertButton")
                .alert("Welcome", isPresented: $showAlert) {

                } message: {
                    Text("You are now signed in!")
                }
                
                NavigationLink {
                    Text("Destination")
                } label: {
                    Text("Navigate")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .clipShape(.rect(cornerRadius: 10))
                }
                .accessibilityIdentifier("NavlinkToDestination")

            }
            .padding()
            .navigationTitle("Welcome")
        }
    }
}
