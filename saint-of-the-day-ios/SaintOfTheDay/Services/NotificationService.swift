import Foundation
import UserNotifications

@MainActor
final class NotificationService {
    static let shared = NotificationService()
    private let center = UNUserNotificationCenter.current()
    private let notificationID = "daily-saint-8am"

    private init() {}

    func requestPermissionIfNeeded() async -> Bool {
        let settings = await center.notificationSettings()
        switch settings.authorizationStatus {
        case .authorized, .provisional:
            return true
        case .notDetermined:
            return (try? await center.requestAuthorization(options: [.alert, .sound, .badge])) ?? false
        default:
            return false
        }
    }

    func rescheduleIfNeeded() async {
        guard await isPermissionGranted() else { return }
        guard !(await isAlreadyScheduled()) else { return }
        await scheduleDailyNotification()
    }

    func scheduleDailyNotification() async {
        let content = UNMutableNotificationContent()
        content.title = "Saint of the Day"
        content.body = "Open the app to meet today's featured saint."
        content.sound = .default
        content.badge = 1

        var components = DateComponents()
        components.hour = 8
        components.minute = 0

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: true
        )
        let request = UNNotificationRequest(
            identifier: notificationID,
            content: content,
            trigger: trigger
        )
        try? await center.add(request)
    }

    func clearBadge() {
        UNUserNotificationCenter.current().setBadgeCount(0) { _ in }
    }

    // MARK: - Private

    private func isPermissionGranted() async -> Bool {
        let settings = await center.notificationSettings()
        return settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional
    }

    private func isAlreadyScheduled() async -> Bool {
        let pending = await center.pendingNotificationRequests()
        return pending.contains { $0.identifier == notificationID }
    }
}
