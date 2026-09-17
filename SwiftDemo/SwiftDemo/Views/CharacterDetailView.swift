import SwiftUI
import UIKit

struct CharacterDetailView: View {
    
    let character: Character
    @State private var shareableImage: UIImage?
    @State private var showingShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                AsyncImage( url: URL(string: character.image)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                        
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundStyle(.red)
                        
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(character.name) character image")
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(character.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    DetailRow(title: "Species", value: character.species)
                    DetailRow(title: "Status", value: character.status)
                    DetailRow(title: "Origin", value: character.origin.name)
                    
                    if !character.type.isEmpty {
                        DetailRow(title: "Type", value: character.type)
                    }
                    
                    DetailRow(title: "Created", value: formattedDate)
                }
            }
            .padding()
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            guard let url = URL(string: character.image) else {
                return
            }

            do {
                let (data, response) = try await URLSession.shared.data(from: url)

                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode,
                      let image = UIImage(data: data) else {
                    return
                }

                shareableImage = image
            } catch {
                return
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .accessibilityLabel("Share character")
                .disabled(shareableImage == nil)
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            if let shareableImage {
                ShareSheet(
                    image: shareableImage,
                    text: shareText
                )
            }
        }
    }
    
    private var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        
        guard let date = formatter.date(from: character.created) else {
            return character.created
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .none
        
        return displayFormatter.string(from: date)
    }
    
    private var shareText: String {
        """
        \(character.name)
        Species: \(character.species)
        Status: \(character.status)
        Origin: \(character.origin.name)
        """
    }
}

private struct DetailRow: View {

    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.body)
        }
    }
}
