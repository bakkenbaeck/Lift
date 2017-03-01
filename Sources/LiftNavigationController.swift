import UIKit

open class LiftNavigationController: UIViewController, SwitchableFloorDelegate {
    public static let navigationBarHeight = CGFloat(64.0)
    weak var switchableFloorDelegate: SwitchableFloorDelegate?

    open var topViewController = UIViewController() {
        didSet {
            self.topViewController.view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    open var bottomViewControllers = [UIViewController]() {
        didSet {
            self.bottomController.bottomViewControllers = bottomViewControllers
            self.roomIndicatorController.roomTitles = self.bottomViewControllers.map { controller in controller.title ?? ""}
        }
    }

    var currentFloor: Floor = .top
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

    lazy var bottomController: BottomController = {
        let controller = BottomController(parentController: self)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.backgroundColor = .white

        return controller
    }()

    lazy var roomIndicatorController: RoomIndicatorController = {
        let roomIndicatorView = RoomIndicatorController()

        return roomIndicatorView
    }()

    public init() {
        super.init(nibName: nil, bundle: nil)

        self.roomIndicatorController.switchableRoomDelegate = self.bottomController
        self.bottomController.switchableRoomDelegate = self.roomIndicatorController
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.addSubviewsAndConstraints()
    }

    func addSubviewsAndConstraints() {
        self.view.translatesAutoresizingMaskIntoConstraints = false

        self.view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        self.view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true

        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.topViewController.view)
        self.scrollView.addSubview(self.roomIndicatorController.view)
        self.scrollView.addSubview(self.bottomController.view)

        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.scrollView.heightAnchor.constraint(greaterThanOrEqualTo: self.view.heightAnchor).isActive = true

        self.topViewController.view.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.topViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.topViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.topViewController.view.heightAnchor.constraint(equalToConstant: self.view.bounds.height - LiftNavigationController.navigationBarHeight).isActive = true

        self.roomIndicatorController.view.topAnchor.constraint(equalTo: self.topViewController.view.bottomAnchor).isActive = true
        self.roomIndicatorController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.roomIndicatorController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.roomIndicatorController.view.heightAnchor.constraint(equalToConstant: LiftNavigationController.navigationBarHeight).isActive = true

        self.bottomController.view.topAnchor.constraint(equalTo: self.roomIndicatorController.roomCollectionView.bottomAnchor).isActive = true
        self.bottomController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.bottomController.view.widthAnchor.constraint(greaterThanOrEqualTo: self.view.widthAnchor).isActive = true
        self.bottomController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -LiftNavigationController.navigationBarHeight).isActive = true
        self.bottomController.view.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
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

            self.setCurrentFloor(Floor(rawValue: index) ?? self.currentFloor)
        }
    }
}

extension LiftNavigationController: SwitchableFloor {
    func didMoveToTop() {
        var origin = self.view.bounds.origin
        origin.y = 0
        scrollView.setContentOffset(origin, animated: true)
    }

    func didMoveToBottom() {
        var origin = self.view.bounds.origin
        origin.y = self.view.bounds.height - LiftNavigationController.navigationBarHeight
        scrollView.setContentOffset(origin, animated: true)
    }
}