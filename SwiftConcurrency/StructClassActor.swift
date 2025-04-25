//
//  StructClassActor.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-04-25.
//

import SwiftUI

/*
 Value Types:
 - Struct, Enum, String, Int, etc.
 - Stored in the Stack
 - Faster
 - Thread safe
 - When you assign or pass value type, a new copy of data is created.
 
 Reference Types:
 - Class, Function, Actor
 - Stored in the Heap
 - Slower, but syncronized
 - Not thread safe
 - When you assign or pass reference type, a new reference to original will be created. (pointer)
 
 - - - - - - - - - - - - - - - - - - -
 
 Stack:
 - Stores value types
 - Variables allocated on the stack are stored directly to the memory, and access to this memory is very fast
 - Each Thread has it's own Stack
 
 Heap:
 - Stores Reference types
 - Shares across threads
 
 - - - - - - - - - - - - - - - - - - -
 
 Struct:
 - Based on Values
 - Can be mutated
 - Stored in the Stack
 
 Classes:
 - Based on References. (Instances)
 - Stored in the Heap
 - Inherit from other classes
 
 Actor:
 - Same as Class, but thread safe!
 
 - - - - - - - - - - - - - - - - - - -
 
 Structs: Data Models, Views
 Classes: ViewModels
 Actors: Shared 'Manager' and 'Data Store' classes
 
 */

struct MyStruct {
    var title: String
}

//immutable
struct CustomStruct {
    let title: String
    
    func updateTitle(title: String) -> CustomStruct {
        CustomStruct(title: title)
    }
}

class MYClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(title: String) {
        self.title = title
    }
}
actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    func updateTitle(title: String) {
        self.title = title
    }
}

final class ViewModel: ObservableObject {
    @Published var title: String = "Hello, World!"
}

struct StructClassActorView: View {
    
    @State private var isActive: Bool = false
    
    var body: some View {
        StructClassActor(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
}

struct StructClassActor: View {
    
    @StateObject private var vm = ViewModel()
    let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
    }
    
    var body: some View {
        Text("Hello, World!")
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .background(isActive ? .blue : .red)
    }
    
    private func runTest() {
        print("test started")
    }
    
    private func structTest1() {
        let objA = MyStruct(title: "title")
        print("ObjA: ", objA.title)
        
        //pass the values of objA to objB
        var objB = objA
        print("ObjB: ", objB.title)
        
        objB.title = "new title"
        
        print("ObjA: ", objA.title)
        print("ObjB: ", objB.title)
    }
    
    private func structTest2() {
        var str1 = MyStruct(title: "Title1")
        print("struct1: ", str1.title)
        str1.title = "Title2"
        print("struct1: ", str1.title)
        
        var struct2 = CustomStruct(title: "Title1")
        print("struct2: ", struct2.title)
        struct2 = CustomStruct(title: "Title2")
        print("struct2: ", struct2.title)
    }
    
    private func classTest1() {
        let objA = MYClass(title: "title")
        print("ObjA: ", objA.title)
        
        //pass the reference of objA to objB
        let objB = objA
        print("ObjB: ", objB.title)
        
        objB.title = "new title"
        
        print("ObjA: ", objA.title)
        print("ObjB: ", objB.title)
    }
    
    private func actorTest1() {
        Task {
            let objA = MyActor(title: "title")
            print("ObjA: ", await objA.title)
            
            //pass the reference of objA to objB
            let objB = objA
            await print("ObjB: ", objB.title)
            
            await objB.updateTitle(title: "new title")
            
            await print("ObjA: ", objA.title)
            await print("ObjB: ", objB.title)
        }
    }
    
}

#Preview {
    StructClassActorView()
}
