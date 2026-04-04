import Foundation

struct Saint: Codable, Identifiable {
    var id: String { canonicalName }
    let canonicalName: String
    let feastDay: String
    let feastMonth: Int
    let feastDayOfMonth: Int
    let timePeriod: String?
    let shortBio: String
    let imageURL: URL?
    let wikipediaTitle: String
    let sections: [SaintSection]
    let fetchedDate: Date
}
