import Foundation
import Observation

@Observable
final class TodayViewModel {
    var saint: Saint? {
        if case .loaded(let s) = repository.state { return s }
        return nil
    }

    var isLoading: Bool {
        if case .loading = repository.state { return true }
        return false
    }

    var errorMessage: String? {
        if case .failed(let error) = repository.state {
            return error.localizedDescription
        }
        return nil
    }

    private let repository: SaintRepository

    init(repository: SaintRepository = SaintRepository()) {
        self.repository = repository
    }

    func loadIfNeeded() async {
        if case .idle = repository.state {
            await repository.fetchTodaySaint()
        }
    }

    func refresh() async {
        await repository.refresh()
    }
}
