import UIKit

open class LiftNavigationController: UIViewController {
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
            self.roomIndicatorController.roomTitles = self.bottomViewControllers.map { controller in controller.title ?? "" }
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
        let roomIndicatorController = RoomIndicatorController()
        roomIndicatorController.switchableFloorDelegate = self

        return roomIndicatorController
    }()

    lazy var contentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .clear

        return view
    }()

    public init() {
        super.init(nibName: nil, bundle: nil)

        self.switchableFloorDelegate = self.roomIndicatorController

        self.roomIndicatorController.switchableRoomDelegate = self.bottomController
        self.bottomController.scrollableRoomDelegate = self.roomIndicatorController
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
        self.scrollView.addSubview(self.contentView)

        self.contentView.addSubview(self.topViewController.view)
        self.contentView.addSubview(self.roomIndicatorController.view)
        self.contentView.addSubview(self.bottomController.view)

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

        self.roomIndicatorController.view.topAnchor.constraint(equalTo: self.topViewController.view.bottomAnchor).isActive = true
        self.roomIndicatorController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.roomIndicatorController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.roomIndicatorController.view.heightAnchor.constraint(equalToConstant: LiftNavigationController.navigationBarHeight).isActive = true

        self.bottomController.view.topAnchor.constraint(equalTo: self.roomIndicatorController.roomCollectionView.bottomAnchor).isActive = true
        self.bottomController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.bottomController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.bottomController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -LiftNavigationController.navigationBarHeight).isActive = true
        self.bottomController.view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
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

            guard let floorType = Floor(rawValue: index), floorType != self.currentFloor else { return }
            self.setCurrentFloor(floorType)
            self.switchableFloorDelegate?.didSwipeToFloor(floorType, on: self)
        }
    }
}

extension LiftNavigationController: SwitchableFloor, SwitchableFloorDelegate {

    func moveToTop() {
        var origin = self.view.bounds.origin
        origin.y = 0
        scrollView.setContentOffset(origin, animated: true)
    }

    func moveToBottom() {
        var origin = self.view.bounds.origin
        origin.y = self.view.bounds.height - LiftNavigationController.navigationBarHeight
        scrollView.setContentOffset(origin, animated: true)
    }

    func didNavigateToFloor(_ floor: Floor, on viewController: RoomIndicatorController) {
        self.setCurrentFloor(floor)
    }
}
