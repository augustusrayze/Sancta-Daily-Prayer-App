import Foundation
import Observation

enum LoadState {
    case idle
    case loading
    case loaded(Saint)
    case failed(Error)
}

@Observable
final class SaintRepository {
    private(set) var state: LoadState = .idle

    private let vaticanService = VaticanNewsService()
    private let wikipediaService = WikipediaService()
    private let cacheService = CacheService()

    func fetchTodaySaint() async {
        let today = Date()

        // 1. Check cache first
        if let cached = try? cacheService.load(for: today) {
            state = .loaded(cached)
            return
        }

        state = .loading

        do {
            // 2. Get saint name from Vatican News
            let (name, _) = try await vaticanService.fetchSaint(for: today)

            // 3. Get full content from Wikipedia
            let saint = try await wikipediaService.fetchSaint(named: name)

            // 4. Persist to cache
            try? cacheService.save(saint, for: today)

            state = .loaded(saint)
        } catch {
            // Try returning a stale cache as fallback
            if let stale = try? cacheService.load(for: today) {
                state = .loaded(stale)
            } else {
                state = .failed(error)
            }
        }
    }

    func refresh() async {
        state = .idle
        await fetchTodaySaint()
    }
}
