import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError
}

struct CharacterService: CharacterServiceProtocol {

    func fetchCharacters(searchText: String) async throws -> [Character] {
        var components = URLComponents(
            string: "https://rickandmortyapi.com/api/character/"
        )

        components?.queryItems = [
            URLQueryItem(name: "name", value: searchText)
        ]

        guard let url = components?.url else {
            throw APIError.invalidURL
        }

        let (data, urlResponse) = try await URLSession.shared.data(from: url)

        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw APIError.httpError(httpResponse.statusCode)
        }

        do {
            let characterResponse = try JSONDecoder().decode(
                CharacterResponse.self,
                from: data
            )

            return characterResponse.results
        } catch {
            throw APIError.decodingError
        }
    }
}
