//
//  UnitTestingBootcamp.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-05-07.
//

import SwiftUI

struct UnitTestingBootcamp: View {
    
    @StateObject private var vm: UnitTestingBootcampViewModel
    
    init(isPremium: Bool) {
        _vm = StateObject(wrappedValue: UnitTestingBootcampViewModel(isPremium: isPremium))
    }
    
    var body: some View {
        Text(vm.isPremium.description)
    }
}

#Preview {
    UnitTestingBootcamp(isPremium: true)
}
