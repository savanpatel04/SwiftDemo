import SwiftUI

struct CharacterDetailView: View {
    
    let character: Character
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                AsyncImage(url: URL(string: character.image)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                } placeholder: {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                
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
