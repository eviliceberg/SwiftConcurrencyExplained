//
//  SendableProtocol.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-04-26.
//

import SwiftUI

actor CurrentUserManager {
    
    func update(userInfo: MyUserInfo) {
        
    }
    
}

struct MyUserInfo: Sendable {
    let name: String
}

final class MyClassUserInfo: @unchecked Sendable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

class SendableProtocolViewModel: ObservableObject {
    
    //@Published var
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async {
        let info = MyUserInfo(name: "User info")
        await manager.update(userInfo: info)
    }
    
}

struct SendableProtocol: View {
    
    @StateObject private var vm = SendableProtocolViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {
                
            }
    }
}

#Preview {
    SendableProtocol()
}
