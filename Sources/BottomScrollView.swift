import UIKit

class BottomScrollView: UIScrollView {

    var targetOffset: CGPoint?

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
        let targetViewControllerIndex = Int(targetContentOffset.pointee.x / UIScreen.main.bounds.width)

        let newX = CGFloat(targetViewControllerIndex) *  UIScreen.main.bounds.width
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
