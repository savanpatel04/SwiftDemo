import Foundation

struct Character: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let origin: Origin
    let image: String
    let created: String

}

struct Origin: Codable, Hashable {
    let name: String
}

struct CharacterResponse: Codable {
    let results: [Character]
}
