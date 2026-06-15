import SwiftUI

#if canImport(UIKit)
import UIKit

@MainActor
public struct SnapshotTools {
    public static func render<V: View>(_ view: V, size: CGSize = CGSize(width: 375, height: 812)) -> UIImage {
        let controller = UIHostingController(rootView: view)
        let view = controller.view
        view?.bounds = CGRect(origin: .zero, size: size)
        view?.backgroundColor = .clear
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
#endif
