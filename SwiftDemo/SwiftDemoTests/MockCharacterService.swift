import Foundation
@testable import SwiftDemo

final class MockCharacterService: CharacterServiceProtocol {

    var charactersToReturn: [Character]
    var errorToThrow: Error?
    var receivedSearchText: String?

    init(
        charactersToReturn: [Character] = [],
        errorToThrow: Error? = nil
    ) {
        self.charactersToReturn = charactersToReturn
        self.errorToThrow = errorToThrow
    }

    func fetchCharacters(searchText: String) async throws -> [Character] {
        receivedSearchText = searchText

        if let errorToThrow {
            throw errorToThrow
        }

        return charactersToReturn
    }
}
