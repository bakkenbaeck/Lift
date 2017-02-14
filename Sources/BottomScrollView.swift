import UIKit

class BottomScrollView: UIScrollView {

    var targetOffset: CGPoint?
    var currentIndex = 0

    var bottomViewControllers: [UIViewController]? {
        didSet {
            guard let bottomViewControllers = self.bottomViewControllers else { return }
            self.addBottomViewControllersAndConstraints(bottomViewControllers)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addBottomViewControllersAndConstraints(_ bottomViewControllers: [UIViewController]) {
        for (index, viewController) in bottomViewControllers.enumerated() {
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(viewController.view)

            let isFirstViewController = index == 0
            let isLastViewController = index == bottomViewControllers.count - 1
            let isMiddleViewController = !isFirstViewController && !isLastViewController

            viewController.view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            viewController.view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            viewController.view.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

            if isFirstViewController {
                viewController.view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            }

            if isMiddleViewController {
                let priorViewController = bottomViewControllers[index - 1]
                viewController.view.leftAnchor.constraint(equalTo: priorViewController.view.rightAnchor).isActive = true
            }

            if isLastViewController {
                let priorViewController = bottomViewControllers[index - 1]
                viewController.view.leftAnchor.constraint(equalTo: priorViewController.view.rightAnchor).isActive = true

                viewController.view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            }
        }
    }
}

extension BottomScrollView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView.contentOffset.x > 0 && scrollView.contentOffset.x < (scrollView.contentSize.width - UIScreen.main.bounds.width) else { return }

        if velocity.x == 0 {
            self.currentIndex = Int((scrollView.contentOffset.x +  UIScreen.main.bounds.width*0.5) / UIScreen.main.bounds.width)
        } else {
            let isScrollingLeft = scrollView.contentOffset.x > targetContentOffset.pointee.x
            let isScrollingRight = scrollView.contentOffset.x < targetContentOffset.pointee.x

            if isScrollingLeft && self.currentIndex > 0 {
                self.currentIndex = self.currentIndex - 1
            }
            if isScrollingRight && self.currentIndex < (self.bottomViewControllers?.count ?? 0) - 1 {
                self.currentIndex = self.currentIndex + 1
            }
        }

        let newX = CGFloat(self.currentIndex) *  UIScreen.main.bounds.width
        self.targetOffset = CGPoint(x: newX, y: 0)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let targetOffset = self.targetOffset,decelerate == false else { return }
        scrollView.setContentOffset(targetOffset, animated: true)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        guard let targetOffset = self.targetOffset else { return }
        scrollView.setContentOffset(targetOffset, animated: true)
    }
}