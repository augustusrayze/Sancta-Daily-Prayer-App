import SwiftUI

@main
struct SaintOfTheDayApp: App {
    init() {
        URLCache.shared = URLCache(
            memoryCapacity: 20 * 1024 * 1024,
            diskCapacity: 100 * 1024 * 1024,
            directory: nil
        )
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.light)
                .task {
                    await NotificationService.shared.rescheduleIfNeeded()
                }
        }
    }
}
