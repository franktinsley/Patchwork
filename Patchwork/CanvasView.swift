import SwiftUI

struct CanvasView<Content: View>: UIViewRepresentable {
    var content: Content
    @Binding var contentOffset: CGPoint
    @Binding var zoomScale: CGFloat
    let size: CGSize
    let defaultZoomScale: CGFloat
    let minimumZoomScale: CGFloat
    let maximumZoomScale: CGFloat

    init(size: CGSize = CGSize(width: 20000, height: 20000), defaultZoomScale: CGFloat = 0.5, minimumZoomScale: CGFloat = 0.05, maximumZoomScale: CGFloat = 5, contentOffset: Binding<CGPoint>, zoomScale: Binding<CGFloat>, @ViewBuilder content: @escaping () -> Content) {
        self.size = size
        self.defaultZoomScale = defaultZoomScale
        self.minimumZoomScale = minimumZoomScale
        self.maximumZoomScale = maximumZoomScale
        self._contentOffset = contentOffset
        self._zoomScale = zoomScale
        self.content = content()
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.contentOffset = contentOffset
//        scrollView.zoomScale = defaultZoomScale
        scrollView.minimumZoomScale = minimumZoomScale
        scrollView.maximumZoomScale = maximumZoomScale
//        scrollView.contentInsetAdjustmentBehavior = .never

        let hostingController = UIHostingController(rootView: content)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(hostingController.view)
        context.coordinator.hostingController = hostingController

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostingController.view.widthAnchor.constraint(equalToConstant: size.width),
            hostingController.view.heightAnchor.constraint(equalToConstant: size.height)
        ])
        
        scrollView.setZoomScale(defaultZoomScale, animated: false)
        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        DispatchQueue.main.async {
            if uiView.zoomScale != self.zoomScale {
                uiView.setZoomScale(self.zoomScale, animated: true)
            }
            uiView.contentOffset = self.contentOffset
        }
        context.coordinator.hostingController?.rootView = content
    }

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.contentOffsetBinding = _contentOffset
        coordinator.zoomScaleBinding = _zoomScale
        return coordinator
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var hostingController: UIHostingController<Content>? = nil
        var contentOffsetBinding: Binding<CGPoint>?
        var zoomScaleBinding: Binding<CGFloat>?

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            contentOffsetBinding?.wrappedValue = scrollView.contentOffset
        }

        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            zoomScaleBinding?.wrappedValue = scrollView.zoomScale
        }

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return hostingController?.view
        }
    }
}
