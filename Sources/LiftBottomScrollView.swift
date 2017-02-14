import UIKit

class LiftBottomScrollView: UIScrollView {

    var bottomViewControllers: [UIViewController]? {
        didSet {
            guard let bottomViewControllers = self.bottomViewControllers else { return }
            self.addBottomViewControllersAndConstraints(bottomViewControllers)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addBottomViewControllersAndConstraints(_ bottomViewControllers: [UIViewController]) {
        for (index, viewController) in bottomViewControllers.enumerated() {
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(viewController.view)

            let firstViewController = index == 0
            let lastViewController = index == bottomViewControllers.count - 1
            let middleViewController = !firstViewController && !lastViewController
            
            viewController.view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            viewController.view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            viewController.view.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

            if firstViewController {
                viewController.view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            }

            if middleViewController {
                let priorViewController = bottomViewControllers[index - 1]
                viewController.view.leftAnchor.constraint(equalTo: priorViewController.view.rightAnchor).isActive = true
            }

            if lastViewController {
                let priorViewController = bottomViewControllers[index - 1]
                viewController.view.leftAnchor.constraint(equalTo: priorViewController.view.rightAnchor).isActive = true

                viewController.view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            }

        }
    }
}
