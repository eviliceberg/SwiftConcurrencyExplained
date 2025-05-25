//
//  AnimatableData.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-05-25.
//

import SwiftUI

struct AnimatableData: View {
    
    @State private var animate: Bool = false
    
    var body: some View {
        ZStack {
            Pacman(mouthDegrees: animate ? 1 : 30)
                .frame(width: 250, height: 250)
        }
        .onAppear {
            withAnimation(.easeInOut.repeatForever()) {
                animate.toggle()
            }
        }
    }
}

#Preview {
    AnimatableData()
}

struct RectangleCornerAnimation: Shape {
    
    var cornerRadius: CGFloat
    
    var animatableData: CGFloat {
        get { cornerRadius }
        set { cornerRadius = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .zero)
            
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
            path.addArc(
                center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 90),
                clockwise: false
            )
            path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
    }
}

struct Pacman: Shape {
    
    var mouthDegrees: Double
    
    var animatableData: Double {
        get {
            mouthDegrees
        }
        set {
            mouthDegrees = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            
            path.addArc(
                center: CGPoint(
                    x: rect.midX,
                    y: rect.midY
                ),
                radius: rect.height / 2,
                startAngle: Angle(degrees: -mouthDegrees),
                endAngle: Angle(degrees: mouthDegrees),
                clockwise: true
            )
        }
    }
    
    
}
