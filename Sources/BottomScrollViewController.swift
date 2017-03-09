import UIKit

class BottomScrollViewController: UIViewController {
    weak var horizontallyScrollableDelegate: HorizontallyScrollableDelegate?
    weak var verticallySwitchableDelegate: VerticallySwitchableDelegate?

    var horizontalPosition = 0

    fileprivate unowned var parentController: UIViewController

    var bottomViewControllers: [BottomController]? {
        didSet {
            guard let bottomViewControllers = self.bottomViewControllers else { return }
            self.addBottomViewControllersAndConstraints(bottomViewControllers)
        }
    }

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.scrollsToTop = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast

        return scrollView
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear

        return view
    }()

    init(parentController: UIViewController) {
        self.parentController = parentController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addBottomViewControllersAndConstraints(_ bottomViewControllers: [BottomController]) {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)

        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.contentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.contentView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true

        self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor).isActive = true

        for (index, viewController) in bottomViewControllers.enumerated() {
            viewController.bottomControllerDelegate = self
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(viewController.view)

            let isFirstViewController = index == 0
            let isLastViewController = index == bottomViewControllers.count - 1
            let isMiddleViewController = !isFirstViewController && !isLastViewController

            viewController.view.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
            viewController.view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            viewController.view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true

            if isFirstViewController {
                viewController.view.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
            }

            if isMiddleViewController {
                let priorViewController = bottomViewControllers[index - 1]
                viewController.view.leftAnchor.constraint(equalTo: priorViewController.view.rightAnchor).isActive = true
            }

            if isLastViewController {
                let priorViewController = bottomViewControllers[index - 1]
                viewController.view.leftAnchor.constraint(equalTo: priorViewController.view.rightAnchor).isActive = true

                viewController.view.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
            }
        }
    }

    func showPage(at index: Int) {
        self.goToPage(index, animated: true)
    }

    fileprivate func goToPage(_ page: Int, animated: Bool) {
        self.loadScrollViewWithPage(page - 1)
        self.loadScrollViewWithPage(page)
        self.loadScrollViewWithPage(page + 1)

        var contentOffset = self.scrollView.bounds.origin
        contentOffset.x = self.scrollView.bounds.size.width * CGFloat(page)
        contentOffset.y = 0

        self.scrollView.setContentOffset(contentOffset, animated: animated)
    }

    fileprivate func loadScrollViewWithPage(_ page: Int) {
        let numPages = self.bottomViewControllers?.count ?? 0
        if page >= numPages || page < 0 {
            return
        }

        if let controller = self.bottomViewControllers?[page], controller.view.superview == nil {
            self.parentController.addChildViewController(controller)
            self.scrollView.addSubview(controller.view)
            controller.didMove(toParentViewController: parentController)
        }
    }
}

extension BottomScrollViewController: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.horizontallyScrollableDelegate?.viewController(self, didScrollTo: scrollView.contentOffset)

        let pageWidth = UIScreen.main.bounds.width
        let horizontalPosition = Int(floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)

        if horizontalPosition != self.horizontalPosition {
            self.horizontalPosition = horizontalPosition

            self.loadScrollViewWithPage(horizontalPosition - 1)
            self.loadScrollViewWithPage(horizontalPosition)
            self.loadScrollViewWithPage(horizontalPosition + 1)
        }
    }
}

extension BottomScrollViewController: HorizontallySwitchableDelegate {

    func viewController(_ viewController: UIViewController, didSelectPosition position: Int) {
        guard let _ = viewController as? NavigationBarController else { return }

        var scrollBounds = self.scrollView.bounds
        scrollBounds.origin.x = self.view.bounds.width * CGFloat(position)

        UIView.animate(withDuration: 0.2, animations: {
            self.scrollView.bounds = scrollBounds
        }, completion: { b in

            // WARNING: look into this, can't i just use the horizontalPosition formt he delegate here?
            let pageWidth = UIScreen.main.bounds.width
            let horizontalPosition = Int(floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)

            if horizontalPosition != self.horizontalPosition {
                self.horizontalPosition = horizontalPosition

                self.loadScrollViewWithPage(horizontalPosition - 1)
                self.loadScrollViewWithPage(horizontalPosition)
                self.loadScrollViewWithPage(horizontalPosition + 1)
            }
        })
    }
}


extension BottomScrollViewController: BottomControllerDelegate {
    func requestToSwitchToTop(from bottomContentViewController: BottomController) {
      self.verticallySwitchableDelegate?.didSwitchToPosition(.top, on: self)
    }
}
