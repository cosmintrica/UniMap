import SwiftUI

@main
struct UniMapApp: App {
    // Lazy initialization pentru ProfileStore
    @StateObject private var profileStore = ProfileStore.shared
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(profileStore)
        }
    }
}
