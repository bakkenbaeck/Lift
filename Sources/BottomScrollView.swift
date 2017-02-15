import UIKit

protocol PaginatedScrollViewDelegate: class {
    func didMove(from fromIndex: Int, to toIndex: Int, on bottomScrollView: BottomScrollView)
}

class BottomScrollView: UIScrollView {
    open weak var viewDelegate: PaginatedScrollViewDelegate?
    fileprivate unowned var parentController: UIViewController

    fileprivate var currentPage = 0

    var bottomViewControllers: [UIViewController]? {
        didSet {
            guard let bottomViewControllers = self.bottomViewControllers else { return }
            self.addBottomViewControllersAndConstraints(bottomViewControllers)
        }
    }

    init(parentController: UIViewController) {
        self.parentController = parentController
        super.init(frame: CGRect.zero)

        self.isPagingEnabled = true
        self.scrollsToTop = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.delegate = self
        self.decelerationRate = UIScrollViewDecelerationRateFast
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

    func showPage(at index: Int) {
        self.goToPage(index, animated: true)
    }

    fileprivate func goToPage(_ page: Int, animated: Bool) {
        self.loadScrollViewWithPage(page - 1)
        self.loadScrollViewWithPage(page)
        self.loadScrollViewWithPage(page + 1)

        var contentOffset = self.bounds.origin
        contentOffset.x = bounds.size.width * CGFloat(page)
        contentOffset.y = 0

        self.setContentOffset(contentOffset, animated: animated)
    }

    fileprivate func loadScrollViewWithPage(_ page: Int) {
        let numPages = self.bottomViewControllers?.count ?? 0
        if page >= numPages || page < 0 {
            return
        }

        if let controller = self.bottomViewControllers?[page], controller.view.superview == nil {
            self.parentController.addChildViewController(controller)
            self.addSubview(controller.view)
            controller.didMove(toParentViewController: parentController)
        }
    }
}

extension BottomScrollView: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = UIScreen.main.bounds.width
        let page = Int(floor((contentOffset.x - pageWidth / 2) / pageWidth) + 1)

        if page != currentPage {
            self.viewDelegate?.didMove(from: currentPage, to: page, on: self)
        }

        self.currentPage = page

        self.loadScrollViewWithPage(page - 1)
        self.loadScrollViewWithPage(page)
        self.loadScrollViewWithPage(page + 1)
    }
}
