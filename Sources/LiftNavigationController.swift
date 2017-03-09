import UIKit

open class LiftNavigationController: UIViewController {
    public static let navigationBarHeight = CGFloat(64.0)
    weak var verticallySwitchableDelegate: VerticallySwitchableDelegate?

    open var navigationBarFont: UIFont?
    open var topBarButtonImage: UIImage?
    open var bottomBarButtonImage: UIImage?

    open var topViewController = UIViewController() {
        didSet {
            self.topViewController.view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    open var bottomViewControllers = [BottomController]()

    var verticalPosition: VerticalPosition = .top
    var shouldEvaluatePageChange = false

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.scrollsToTop = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.bounces = false

        return scrollView
    }()

    lazy var bottomScrollViewController: BottomScrollViewController = {
        let controller = BottomScrollViewController(parentController: self)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.backgroundColor = .white
        controller.verticallySwitchableDelegate = self

        return controller
    }()

    lazy var navigationBarController: NavigationBarController = {
        let navigationBarController = NavigationBarController()
        navigationBarController.verticallySwitchableDelegate = self

        navigationBarController.font = self.navigationBarFont
        navigationBarController.topButtonImage = self.topBarButtonImage
        navigationBarController.bottomButtonImage = self.bottomBarButtonImage

        return navigationBarController
    }()

    lazy var contentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .clear

        return view
    }()

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.verticallySwitchableDelegate = self.navigationBarController

        self.navigationBarController.horizontallySwitchableDelegate = self.bottomScrollViewController
        self.bottomScrollViewController.horizontallyScrollableDelegate = self.navigationBarController

        self.bottomScrollViewController.bottomViewControllers = bottomViewControllers
        self.navigationBarController.navigationLabels = self.bottomViewControllers.map { controller in controller.title ?? "" }

        self.addSubviewsAndConstraints()
    }

    func addSubviewsAndConstraints() {
        self.view.translatesAutoresizingMaskIntoConstraints = false

        self.view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        self.view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true

        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)

        self.contentView.addSubview(self.topViewController.view)
        self.contentView.addSubview(self.navigationBarController.view)
        self.contentView.addSubview(self.bottomScrollViewController.view)

        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.contentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.contentView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true

        self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true

        self.topViewController.view.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.topViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.topViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.topViewController.view.heightAnchor.constraint(equalToConstant: self.view.bounds.height - LiftNavigationController.navigationBarHeight).isActive = true

        self.navigationBarController.view.topAnchor.constraint(equalTo: self.topViewController.view.bottomAnchor).isActive = true
        self.navigationBarController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.navigationBarController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.navigationBarController.view.heightAnchor.constraint(equalToConstant: LiftNavigationController.navigationBarHeight).isActive = true

        self.bottomScrollViewController.view.topAnchor.constraint(equalTo: self.navigationBarController.navigationLabelCollectionView.bottomAnchor).isActive = true
        self.bottomScrollViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.bottomScrollViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.bottomScrollViewController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -LiftNavigationController.navigationBarHeight).isActive = true
        self.bottomScrollViewController.view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
}

extension LiftNavigationController: UIScrollViewDelegate {

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.shouldEvaluatePageChange = true
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.shouldEvaluatePageChange = false
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if shouldEvaluatePageChange {
            let pageHeight = self.view.bounds.height
            let index = Int(floor((scrollView.contentOffset.y - pageHeight / 4) / pageHeight) + 1)

            guard let verticalPosition = VerticalPosition(rawValue: index), verticalPosition != self.verticalPosition else { return }
            self.setVerticalPosition(verticalPosition)
            self.verticallySwitchableDelegate?.didSwipeToPosition(verticalPosition, on: self)
        }
    }
}

extension LiftNavigationController: VerticallySwitchable, VerticallySwitchableDelegate {

    func moveToTop() {
        var origin = self.view.bounds.origin
        origin.y = 0
        UIView.animate(withDuration: 0.2) {
            self.scrollView.setContentOffset(origin, animated: false)
        }
    }

    func moveToBottom() {
        var origin = self.view.bounds.origin
        origin.y = self.view.bounds.height - LiftNavigationController.navigationBarHeight
        UIView.animate(withDuration: 0.2) {
            self.scrollView.setContentOffset(origin, animated: false)
        }
    }

    func didSwitchToPosition(_ position: VerticalPosition, on viewController: UIViewController) {
        self.setVerticalPosition(position)
        self.verticallySwitchableDelegate?.didSwipeToPosition(position, on: self)
    }
}
