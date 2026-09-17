import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {

    let image: UIImage
    let text: String

    func makeUIViewController(
        context: Context
    ) -> UIActivityViewController {

        let imageSource = ImageShareSource(image: image)
        let textSource = TextShareSource(text: text)

        return UIActivityViewController(
            activityItems: [imageSource, textSource],
            applicationActivities: nil
        )
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) {}
}

private final class ImageShareSource: NSObject, UIActivityItemSource {

    let image: UIImage

    init(image: UIImage) {
        self.image = image
    }

    func activityViewControllerPlaceholderItem(
        _ activityViewController: UIActivityViewController
    ) -> Any {
        image
    }

    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        image
    }
}

private final class TextShareSource: NSObject, UIActivityItemSource {

    let text: String

    init(text: String) {
        self.text = text
    }

    func activityViewControllerPlaceholderItem(
        _ activityViewController: UIActivityViewController
    ) -> Any {
        text
    }

    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        text
    }
}
