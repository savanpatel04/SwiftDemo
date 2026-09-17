import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError
}

protocol CharacterServiceProtocol {
    func fetchCharacters(searchText: String) async throws -> [Character]
}

struct CharacterService : CharacterServiceProtocol {
    func fetchCharacters(searchText: String) async throws-> [Character] {
        
        var components = URLComponents(string: "https://rickandmortyapi.com/api/character")
        
        components?.queryItems = [
            URLQueryItem(name: "name", value: searchText)
            ]
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        
        let(data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            throw APIError.httpError(httpResponse.statusCode)
        }
        
        let characterResponse = try JSONDecoder().decode(CharacterResponse.self, from: data)
        
        return characterResponse.results
    }
}
