import SwiftUI

@main
struct SelfAnalysisApp: App {
    @StateObject private var state = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(state)
        }
    }
}
