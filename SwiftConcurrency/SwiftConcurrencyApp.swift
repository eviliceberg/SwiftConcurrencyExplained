
import SwiftUI

@main
struct SwiftConcurrencyApp: App {
    
    let userIsSignedIn: Bool
    
    init() {
        //let userISSignedIn: Bool = CommandLine.arguments.contains("-UITest_StartSignedIn")
        let value = ProcessInfo.processInfo.environment["-UITest_StartSignedIn2"]
        let userISSignedIn: Bool = value == "true"
        self.userIsSignedIn = userISSignedIn
        
        
    }
    
    var body: some Scene {
        WindowGroup {
            Ex2()
        }
        
    }
}
