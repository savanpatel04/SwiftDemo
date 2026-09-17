import XCTest
@testable import SwiftDemo

@MainActor
final class CharacterTests: XCTestCase {

    func testCharacterDecoding() throws {
        let json = """
        {
            "id": 1,
            "name": "Rick Sanchez",
            "status": "Alive",
            "species": "Human",
            "type": "",
            "origin": {
                "name": "Earth (C-137)"
            },
            "image": "https://example.com/rick.png",
            "created": "2017-11-04T18:48:46.250Z"
        }
        """.data(using: .utf8)!

        let character = try JSONDecoder().decode(
            Character.self,
            from: json
        )

        XCTAssertEqual(character.id, 1)
        XCTAssertEqual(character.name, "Rick Sanchez")
        XCTAssertEqual(character.species, "Human")
        XCTAssertEqual(character.origin.name, "Earth (C-137)")
    }

    func testFetchCharactersUpdatesCharacters() async {
        let character = Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            origin: Origin(name: "Earth (C-137)"),
            image: "https://example.com/rick.png",
            created: "2017-11-04T18:48:46.250Z"
        )

        let mockService = MockCharacterService(
            charactersToReturn: [character]
        )

        let viewModel = CharacterListViewModel(
            characterService: mockService
        )

        await viewModel.fetchCharacters("Rick")

        XCTAssertEqual(viewModel.characters.count, 1)
        XCTAssertEqual(
            viewModel.characters.first?.name,
            "Rick Sanchez"
        )
        XCTAssertEqual(
            mockService.receivedSearchText,
            "Rick"
        )
    }

    func testFetchCharactersWithNotFoundReturnsEmptyResults() async {
        let mockService = MockCharacterService(
            errorToThrow: APIError.httpError(404)
        )

        let viewModel = CharacterListViewModel(
            characterService: mockService
        )

        await viewModel.fetchCharacters("UnknownCharacter")

        XCTAssertTrue(viewModel.characters.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(
            mockService.receivedSearchText,
            "UnknownCharacter"
        )
    }
}
