import SwiftUI

@main
struct UniMapApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(ProfileStore.shared)
        }
    }
}
