import SwiftUI

@MainActor
struct CharacterListView: View {

    @StateObject private var viewModel = CharacterListViewModel(
        characterService: CharacterService()
    )

    @State private var searchText = ""
    @State private var selectedCharacter: Character?
    @State private var retryID = 0

    var body: some View {

        NavigationStack {
            VStack(spacing: 0) {

                TextField("Search characters", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        ContentUnavailableView(
                            "Something Went Wrong",
                            systemImage: "exclamationmark.triangle",
                            description: Text(errorMessage)
                        )

                        Button("Try Again") {
                            retryID += 1
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else if searchText.isEmpty {
                    ContentUnavailableView(
                        "Search Characters",
                        systemImage: "magnifyingglass",
                        description: Text("Enter a character name to start searching.")
                    )
                } else if viewModel.characters.isEmpty && !viewModel.isLoading {
                    ContentUnavailableView(
                        "No Characters Found",
                        systemImage: "person.crop.circle.badge.questionmark",
                        description: Text("Try searching for a different character.")
                    )
                } else {
                    List(viewModel.characters) { character in
                        CharacterRowView(
                            character: character,
                            onTap: {
                                selectedCharacter = character
                            }
                        )
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Characters")
            .navigationDestination(item: $selectedCharacter) { character in
                CharacterDetailView(character: character)
            }
            .overlay {
                if viewModel.isLoading {
                    ZStack {
                        Color.black.opacity(0.05)
                            .ignoresSafeArea()

                        ProgressView("Searching...")
                            .padding()
                            .background(.regularMaterial)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 12)
                            )
                    }
                }
            }
            .task(id: "\(searchText)-\(retryID)") {
                do {
                    try await Task.sleep(for: .milliseconds(300))
                    await viewModel.fetchCharacters(searchText)
                } catch {
                    // Search was cancelled because the text changed.
                }
            }
        }
    }
}
