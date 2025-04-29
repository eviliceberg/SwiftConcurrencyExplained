//
//  ObservableMacro.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-04-29.
//

import SwiftUI

actor DataBase {
    func getNewTitle() -> String {
        "newTitle"
    }
}

@Observable @MainActor
final class ObservableMacroViewModel {
    @ObservationIgnored let db = DataBase()
    var title: String = "Starting Value"
    
    func updateTitle() async {
        title = await db.getNewTitle()
    }
}

struct ObservableMacro: View {
    
    @State private var vm = ObservableMacroViewModel()
    
    var body: some View {
        Text(vm.title)
            .task {
                await vm.updateTitle()
            }
    }
}

#Preview {
    ObservableMacro()
}
