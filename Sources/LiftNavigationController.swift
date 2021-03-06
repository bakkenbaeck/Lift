import UIKit

open class LiftNavigationController: UIViewController {
    public static let switchAnimationDuration = 0.35
    public static let navigationBarHeight: CGFloat = 86.0
    public static let hiddenNavigationBarHeight: CGFloat = 34.0

    fileprivate let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)

    weak var verticallySwitchableDelegate: VerticallySwitchableDelegate?

    var navigationBarStyle: NavigationBarStyle

    open var topViewController = UIViewController() {
        didSet {
            self.topViewController.view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    open var bottomViewControllers = [BottomControllable]()

    var verticalPosition: VerticalPosition = .top

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
        let navigationBarController = NavigationBarController(style: self.navigationBarStyle)
        navigationBarController.verticallySwitchableDelegate = self

        return navigationBarController
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear

        return view
    }()

    public init(navigationBarStyle: NavigationBarStyle = NavigationBarStyle()) {
        self.navigationBarStyle = navigationBarStyle
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.verticallySwitchableDelegate = self.navigationBarController

        self.navigationBarController.horizontallySwitchableDelegate = self.bottomScrollViewController
        self.bottomScrollViewController.horizontallyScrollableDelegate = self.navigationBarController

        self.bottomScrollViewController.bottomViewControllers = bottomViewControllers
        self.navigationBarController.navigationLabels = self.bottomViewControllers.map { controller in controller.controllerTitle ?? "" }

        self.automaticallyAdjustsScrollViewInsets = false
        self.addSubviewsAndConstraints()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationBarController.viewWillAppear(animated)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationBarController.viewDidAppear(animated)
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationBarController.viewWillDisappear(animated)
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.navigationBarController.viewDidDisappear(animated)
    }

    func addSubviewsAndConstraints() {
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
        self.topViewController.view.heightAnchor.constraint(equalToConstant: self.view.bounds.height - LiftNavigationController.hiddenNavigationBarHeight).isActive = true

        self.navigationBarController.view.topAnchor.constraint(equalTo: self.topViewController.view.bottomAnchor).isActive = true
        self.navigationBarController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.navigationBarController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.navigationBarController.view.heightAnchor.constraint(equalToConstant: LiftNavigationController.navigationBarHeight).isActive = true

        self.bottomScrollViewController.view.topAnchor.constraint(equalTo: self.navigationBarController.view.bottomAnchor).isActive = true
        self.bottomScrollViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.bottomScrollViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.bottomScrollViewController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -LiftNavigationController.navigationBarHeight).isActive = true
        self.bottomScrollViewController.view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
}

extension LiftNavigationController: UIScrollViewDelegate {

    /// This is only called when we're scrolling up/down between levels
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // self.verticallySwitchableDelegate?.scrollViewDidScroll(scrollView)
        let total = scrollView.bounds.height - LiftNavigationController.hiddenNavigationBarHeight
        let percentage = scrollView.contentOffset.y / total
        self.verticallySwitchableDelegate?.positionDidUpdate(percentage: percentage)
    }


    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageHeight = self.view.bounds.height
        let index = Int(floor((scrollView.contentOffset.y - pageHeight / 4) / pageHeight) + 1)

        guard let verticalPosition = VerticalPosition(rawValue: index), verticalPosition != self.verticalPosition else { return }
        self.setVerticalPosition(verticalPosition)
        self.verticallySwitchableDelegate?.didSwipeToPosition(verticalPosition, on: self)
    }
}

extension LiftNavigationController: VerticallySwitchable, VerticallySwitchableDelegate {

    func positionDidUpdate(percentage: CGFloat) {
        
    }

    func moveToTop() {
        var origin = self.view.bounds.origin
        origin.y = 0
        let options: UIViewAnimationOptions = [.curveEaseOut, .beginFromCurrentState]

        self.impactFeedbackGenerator.impactOccurred()

        UIView.animate(withDuration: LiftNavigationController.switchAnimationDuration, delay: 0, options: options, animations: {
            self.scrollView.setContentOffset(origin, animated: false)
        }, completion: { _ in
            self.verticallySwitchableDelegate?.positionDidUpdate(percentage: 0.0)
        })
    }

    func moveToBottom() {
        var origin = self.view.bounds.origin
        origin.y = self.view.bounds.height - LiftNavigationController.hiddenNavigationBarHeight
        let options: UIViewAnimationOptions = [.curveEaseOut, .beginFromCurrentState]

        self.impactFeedbackGenerator.impactOccurred()

        UIView.animate(withDuration: LiftNavigationController.switchAnimationDuration, delay: 0, options: options, animations: {
            self.scrollView.setContentOffset(origin, animated: false)
        }, completion: { _ in
            self.verticallySwitchableDelegate?.positionDidUpdate(percentage: 1.0)
        })
    }

    func didSwitchToPosition(_ position: VerticalPosition, on viewController: UIViewController) {
        self.setVerticalPosition(position)
        self.verticallySwitchableDelegate?.didSwipeToPosition(position, on: self)
    }
}

extension LiftNavigationController: PullToNavigateUpDelegate {

    public func didUpdatePullToNavigateUpThreshold(percentage: CGFloat) {
        self.navigationBarController.switchButton.percentageFilled = percentage
    }
}
