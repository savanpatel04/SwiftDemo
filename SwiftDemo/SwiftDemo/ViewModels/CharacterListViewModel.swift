import Foundation
import Combine

@MainActor
final class CharacterListViewModel: ObservableObject {

    @Published private(set) var characters: [Character] = []
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?

    private let characterService: CharacterServiceProtocol

    init(characterService: CharacterServiceProtocol) {
        self.characterService = characterService
    }

    func fetchCharacters(_ searchText: String) async {
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty else {
            characters = []
            return
        }

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            characters = try await characterService.fetchCharacters(
                searchText: trimmedText
            )
        } catch APIError.httpError(let statusCode) where statusCode == 404 {
            characters = []
            errorMessage = nil
        } catch {
            characters = []
            errorMessage = "Unable to load characters. Please try again."
        }
    }
}
