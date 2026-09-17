import Foundation

protocol CharacterServiceProtocol {
    func fetchCharacters(searchText: String) async throws -> [Character]
}

