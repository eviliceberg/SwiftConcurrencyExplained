//
//  MatchedGeometryeffect.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-05-24.
//

import SwiftUI

struct MatchedGeometryeffect: View {
    
    @State private var isClicked: Bool = false
    @Namespace private var namespace
    
    var body: some View {
        VStack {
            if !isClicked {
                Circle()
                    .matchedGeometryEffect(id: "1", in: namespace)
                    .frame(width: 100, height: 100)
                    
            }
            
            Spacer()
            
            if isClicked {
                Circle()
                    .matchedGeometryEffect(id: "1", in: namespace)
                    .frame(width: 300, height: 300)
                    
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.red)
        .onTapGesture {
            withAnimation(.easeInOut) {
                isClicked.toggle()
            }
        }
            
    }
}

#Preview {
    Ex2()
}

struct Ex2: View {
    
    let categories: [String] = ["Books", "Movies", "Music", "All"]
    @State private var selected: String = "All"
    
    @Namespace private var namespace
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(categories, id: \.self) { category in
                ZStack {
                    Text(category)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(selected == category ? .black : .gray)
                    
                    if selected == category {
                        RoundedRectangle(cornerRadius: 34)
                            .fill(Color.pink.opacity(0.4))
                            .matchedGeometryEffect(id: "rect", in: namespace)
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .onTapGesture {
                    if selected != category {
                        withAnimation(.spring) {
                            selected = category
                        }
                    }
                }
                
            }
        }
        .padding(.horizontal)
    }
}
