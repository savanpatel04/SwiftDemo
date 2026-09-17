import SwiftUI

struct CharacterRowView: View {

    let character: Character
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                
                if let imageURL = URL(string: character.image) {
                    CharacterImageView(url: imageURL)
                        .frame(width: 70, height: 70)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 10)
                        )
                } else {
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                        .frame(width: 70, height: 70)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(character.name)
                        .font(.headline)

                    Text(character.species)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(character.name), \(character.species)")
        .accessibilityHint("Double tap to view character details")
    }
}
