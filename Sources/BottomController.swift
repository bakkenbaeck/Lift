import UIKit

class BottomController: UIViewController {
    weak var switchableRoomDelegate: SwitchableRoomDelegate?
    var currentRoom = 0

    fileprivate unowned var parentController: UIViewController

    var bottomViewControllers: [UIViewController]? {
        didSet {
            guard let bottomViewControllers = self.bottomViewControllers else { return }
            self.addBottomViewControllersAndConstraints(bottomViewControllers)
        }
    }

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.isPagingEnabled = true
        scrollView.scrollsToTop = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast

        return scrollView
    }()

    init(parentController: UIViewController) {
        self.parentController = parentController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addBottomViewControllersAndConstraints(_ bottomViewControllers: [UIViewController]) {
        self.view.addSubview(self.scrollView)

        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.scrollView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true

        for (index, viewController) in bottomViewControllers.enumerated() {
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.scrollView.addSubview(viewController.view)

            let isFirstViewController = index == 0
            let isLastViewController = index == bottomViewControllers.count - 1
            let isMiddleViewController = !isFirstViewController && !isLastViewController

            viewController.view.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
            viewController.view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            viewController.view.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor).isActive = true

            if isFirstViewController {
                viewController.view.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
            }

            if isMiddleViewController {
                let priorViewController = bottomViewControllers[index - 1]
                viewController.view.leftAnchor.constraint(equalTo: priorViewController.view.rightAnchor).isActive = true
            }

            if isLastViewController {
                let priorViewController = bottomViewControllers[index - 1]
                viewController.view.leftAnchor.constraint(equalTo: priorViewController.view.rightAnchor).isActive = true

                viewController.view.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor).isActive = true
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

extension BottomController: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.switchableRoomDelegate?.viewController(self, requestToScrollTo: scrollView.contentOffset)

        let pageWidth = UIScreen.main.bounds.width
        let room = Int(floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)

        if room != self.currentRoom {
            self.currentRoom = room

            self.loadScrollViewWithPage(room - 1)
            self.loadScrollViewWithPage(room)
            self.loadScrollViewWithPage(room + 1)
        }
    }
}

extension BottomController: SwitchableRoomDelegate {
    func viewController(_ viewController: UIViewController, requestToScrollTo contentOffset: CGPoint) {
        if let _ = viewController as? RoomIndicatorController {
            var scrollBounds = scrollView.bounds
            scrollBounds.origin = contentOffset

            UIView.animate(withDuration: 0.2, animations: {
                self.scrollView.bounds = scrollBounds
            }, completion: { b in
                let pageWidth = UIScreen.main.bounds.width
                let room = Int(floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)

                if room != self.currentRoom {
                    self.currentRoom = room

                    self.loadScrollViewWithPage(room - 1)
                    self.loadScrollViewWithPage(room)
                    self.loadScrollViewWithPage(room + 1)
                }
            })
        }
    }
}

