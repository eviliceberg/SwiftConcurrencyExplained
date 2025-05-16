//
//  PhaseAniamtion.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-05-16.
//

import SwiftUI

enum AnimationPhases: Equatable, CaseIterable {
    case initial
    case up
    case left
    case right
    
    var yOffset: CGFloat {
        switch self {
        case .initial:
            return 0
        default:
            return -30
        }
    }
    
    var scale: CGFloat {
        switch self {
        case .initial:
            return 1
        default:
            return 1.2
        }
    }
    
    var rotation: CGFloat {
        switch self {
        case .left:
            return -30
        case .right:
            return 30
        default:
            return 0
        }
    }
}

struct PhaseAniamtion: View {
    
    @State private var animate: Bool = false
    
    var body: some View {
        HStack(spacing: 20) {
            Button("Notify me") {
                animate.toggle()
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
            .fontWeight(.semibold)
            .controlSize(.large)
            
            Image(systemName: "bell")
                .resizable()
                .frame(width: 44, height: 44)
                .foregroundStyle(.pink)
                .phaseAnimator(
                    [
                        AnimationPhases.initial,
                        AnimationPhases.up,
                        AnimationPhases.left,
                        AnimationPhases.right,
                        AnimationPhases.left,
                        AnimationPhases.right
                    ], trigger: animate) { content, phase in
                    content
                        .rotationEffect(.degrees(phase.rotation), anchor: .top)
                        .scaleEffect(phase.scale)
                        .offset(y: phase.yOffset)
                        
                    } animation: { phase in
                        switch phase {
                        case .initial, .up:
                                .spring(bounce: 0.5)
                        case .left, .right:
                                .spring(duration: 0.2)
                        }
                    }
  
        }
    }
}

#Preview {
    PhaseAniamtion()
}
