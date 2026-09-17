import SwiftUI

final class ImageCache {
    
    static let shared = ImageCache()
    
    private let cache = NSCache<NSURL, UIImage>()
    
    private init() {}
    
    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    func insert(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}

struct CharacterImageView: View {
    
    let url: URL
    
    @State private var image: UIImage?
    @State private var isLoading = false
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if isLoading {
                ProgressView()
            } else {
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
            }
        }
        .task {
            guard image == nil else { return }
            
            if let cachedImage = ImageCache.shared.image(for: url) {
                image = cachedImage
                return
            }
            
            isLoading = true

            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                guard let downloadedImage = UIImage(data: data) else {
                    isLoading = false
                    return
                }

                ImageCache.shared.insert(downloadedImage, for: url)
                image = downloadedImage
            } catch {
               isLoading = false
               return
            }

            isLoading = false
        }
    }
    
}
