import SwiftUI

struct CharacterRowView: View {

    let character: Character
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: character.image)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 70, height: 70)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                )

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
    }
}
