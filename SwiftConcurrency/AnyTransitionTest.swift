//
//  AnyTransitionTest.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-05-18.
//

import SwiftUI

struct DefaultButton: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(.blue)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(radius: 2)
    }
}

struct RotateViewModifier: ViewModifier {
    
    let rotation: Double
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(rotation))
            .offset(
                x: rotation != 0 ? -400 : 0,
                y: rotation != 0 ? -500 : 0)
    }
}

extension View {
    
    func defaultButton() -> some View {
        self
            .modifier(DefaultButton())
        
    }
    
}

extension AnyTransition {
    
    static var rotate: AnyTransition {
        return AnyTransition.modifier(active: RotateViewModifier(rotation: 180), identity: RotateViewModifier(rotation: 0))
    }
    
    static func rotate(amount: Double) -> AnyTransition {
        return AnyTransition.modifier(active: RotateViewModifier(rotation: amount), identity: RotateViewModifier(rotation: 0))
    }
    
    static var rotateOn: AnyTransition {
        return AnyTransition.asymmetric(
            insertion: .rotate,
            removal: .move(edge: .leading)
        )
    }
    
}

struct AnyTransitionTest: View {
    
    @State private var showRectangle = false
    
    var body: some View {
        ZStack {
            
            VStack {
                Spacer()
                
                if showRectangle {
                    VStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 250, height: 350)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.rotateOn)
                }
                
                Spacer()
                
                Text("Hello, World!")
                    .font(.headline)
                    .defaultButton()
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            showRectangle.toggle()
                        }
                    }
                    .padding(.horizontal, 16)
                    
            }
            
        }
    }
}

#Preview {
    AnyTransitionTest()
}
