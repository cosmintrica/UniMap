import SwiftUI
import FirebaseCore
#if canImport(GoogleSignIn)
import GoogleSignIn
#endif

final class AppDelegate: NSObject, UIApplicationDelegate {
    // DOAR handler-ul de URL (pt. Google). NU mai apela FirebaseApp.configure() aici.
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        #if canImport(GoogleSignIn)
        return GIDSignIn.sharedInstance.handle(url)
        #else
        return false
        #endif
    }
}

@main
struct UniMapApp: App {
    init() {
        // Configure Firebase O SINGURĂ DATĂ aici
        if FirebaseApp.app() == nil { FirebaseApp.configure() }
    }

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var profile = ProfileStore.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(profile)
        }
    }
}
