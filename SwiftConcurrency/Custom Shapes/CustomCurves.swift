//
//  CustomCurves.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-05-25.
//

import SwiftUI

struct CustomCurves: View {
    var body: some View {
        ZStack {
            WaterShape()
                .fill(LinearGradient(colors: [.blue.opacity(0.9), Color.blue.opacity(0.7)], startPoint: .leading, endPoint: .trailing))
                .ignoresSafeArea()
        }
    }
}

#Preview {
    CustomCurves()
}

struct ArcSample: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addArc(
                    center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: rect.height / 2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: false
                )
            
        }
    }
    
    
}

struct ShapeWidthArc: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            //top left
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            //top right
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            //mid right
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            
            //bottom
            //path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: rect.height / 2,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 180),
                clockwise: false
            )
            
            // mid left
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            
        }
    }
    
    
}

struct QuadSample: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .zero)
            path.addQuadCurve(
                to: CGPoint(x: rect.midX, y: rect.midY),
                control: CGPoint(x: rect.maxX - 50, y: rect.minY - 100)
            )
           
        }
    }
}

struct WaterShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            
            path.addQuadCurve(
                to: CGPoint(
                    x: rect.midX / 2,
                    y: rect.midY
                ),
                control: CGPoint(
                    x: rect.width * 0.125,
                    y: rect.height * 0.45
                )
            )
            
            path.addQuadCurve(
                to: CGPoint(
                    x: rect.midX,
                    y: rect.midY
                ),
                control: CGPoint(
                    x: rect.width * 0.375,
                    y: rect.height * 0.55
                )
            )
            
            path.addQuadCurve(
                to: CGPoint(
                    x: rect.midX * 1.5,
                    y: rect.midY
                ),
                control: CGPoint(
                    x: rect.width * 0.625,
                    y: rect.height * 0.45
                )
            )
            
            path.addQuadCurve(
                to: CGPoint(
                    x: rect.maxX,
                    y: rect.midY
                ),
                control: CGPoint(
                    x: rect.width * 0.875,
                    y: rect.height * 0.55
                )
            )
            
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            
//            path.addQuadCurve(
//                to: CGPoint(
//                    x: rect.maxX,
//                    y: rect.midY
//                ),
//                control: CGPoint(
//                    x: rect.width * 0.75,
//                    y: rect.height * 0.75
//                )
//            )
                        
        }
    }
    
    
}
