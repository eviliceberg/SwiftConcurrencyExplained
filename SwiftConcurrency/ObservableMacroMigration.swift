//
//  ObservableMacroMigration.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-04-30.
//

import SwiftUI

/*
 Before iOS 17:
 
 @MainActor
 final class ObservableMacroMigrationViewModel: ObservableObject {
     @Published var title: String = "initial title"
 }

 */

//After iOS 17:
@Observable @MainActor
final class ObservableMacroMigrationViewModel {
    var title: String = "initial title"
}

struct ObservableMacroMigration: View {
    
    //Before iOS 17:
    //
    //@StateObject private var vm = ObservableMacroMigrationViewModel()
    //
    //After iOS 17:
    @State private var vm = ObservableMacroMigrationViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Button(vm.title) {
                vm.title = "Button tapped from view 1"
            }
            ChildViewOne(vm: vm)
            
            ChildViewTwo()
        }
        //Before iOS 17:
        //
        //.environmentObject(vm)
        //
        //After iOS 17:
        .environment(vm)
    }
}

struct ChildViewOne: View {
    
    //Before iOS 17:
    //
    // @ObservedObject var vm: ObservableMacroMigrationViewModel
    //
    //After iOS 17:
    @Bindable var vm: ObservableMacroMigrationViewModel
    
    var body: some View {
        Button(vm.title) {
            vm.title = "Button tapped from child view 1"
        }
    }
}

struct ChildViewTwo: View {
    
    //Before iOS 17:
    //
    // @EnvironmentObject var vm: ObservableMacroMigrationViewModel
    //
    //After iOS 17:
    @Environment(ObservableMacroMigrationViewModel.self) var vm
    
    var body: some View {
        Button(vm.title) {
            vm.title = "Button tapped from child view kjflksdhfjksdhfjkshfsjkfhkdj"
        }
    }
}

#Preview {
    ObservableMacroMigration()
}
