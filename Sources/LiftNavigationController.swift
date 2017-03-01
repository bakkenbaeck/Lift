import UIKit

open class LiftNavigationController: UIViewController {
    public static let navigationBarHeight = CGFloat(64.0)

    open var topViewController = UIViewController() {
        didSet {
            self.topViewController.view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    open var bottomViewControllers = [UIViewController]() {
        didSet {
            self.bottomScrollView.bottomViewControllers = bottomViewControllers
            self.roomIndicatorView.roomTitles = self.bottomViewControllers.map { controller in controller.title ?? ""}
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

    lazy var bottomScrollView: BottomScrollView = {
        let scrollView = BottomScrollView(parentController: self)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.viewDelegate = self

        return scrollView
    }()

    lazy var switchButton: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectSwitchButton), for: .touchUpInside)

        return button
    }()
    
    lazy var roomIndicatorView: RoomIndicatorController = {
        let roomIndicatorView = RoomIndicatorController()
        roomIndicatorView.roomIndicatorDelegate = self

        return roomIndicatorView
    }()

    public init() {
        super.init(nibName: nil, bundle: nil)
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
        self.scrollView.addSubview(self.roomIndicatorView.roomCollectionView)
        self.scrollView.addSubview(self.switchButton)
        self.scrollView.addSubview(self.bottomScrollView)

        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.scrollView.heightAnchor.constraint(greaterThanOrEqualTo: self.view.heightAnchor).isActive = true

        self.topViewController.view.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.topViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.topViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.topViewController.view.heightAnchor.constraint(equalToConstant: self.view.bounds.height - LiftNavigationController.navigationBarHeight).isActive = true

        self.roomIndicatorView.roomCollectionView.topAnchor.constraint(equalTo: self.topViewController.view.bottomAnchor).isActive = true
        self.roomIndicatorView.roomCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.roomIndicatorView.roomCollectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.roomIndicatorView.roomCollectionView.heightAnchor.constraint(equalToConstant: LiftNavigationController.navigationBarHeight).isActive = true

        self.switchButton.bottomAnchor.constraint(equalTo: self.roomIndicatorView.roomCollectionView.bottomAnchor).isActive = true
        self.switchButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.switchButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.switchButton.widthAnchor.constraint(equalToConstant: 44).isActive = true

        self.bottomScrollView.topAnchor.constraint(equalTo: self.roomIndicatorView.roomCollectionView.bottomAnchor).isActive = true
        self.bottomScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.bottomScrollView.widthAnchor.constraint(greaterThanOrEqualTo: self.view.widthAnchor).isActive = true
        self.bottomScrollView.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -LiftNavigationController.navigationBarHeight).isActive = true
        self.bottomScrollView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
    }

    func didSelectSwitchButton() {
        self.setCurrentFloor(self.currentFloor == .top ? .bottom : .top, onViewController: self)
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

            self.currentFloor = Floor(rawValue: index) ?? self.currentFloor
        }
    }
}

extension LiftNavigationController: RoomIndicatorViewDelegate {
    func selectItemAt(_ index: Int, onNavigationBar navigationBar: RoomIndicatorController) {
       self.bottomScrollView.showPage(at: index)
    }
}

extension LiftNavigationController: PaginatedScrollViewDelegate {
    func didMove(from fromIndex: Int, to toIndex: Int, on bottomScrollView: BottomScrollView) {
        self.roomIndicatorView.highLightIndex(index: toIndex )
    }
}

extension LiftNavigationController: Switchable {
    func didMoveToTop(on viewController: UIViewController) {
        var origin = self.view.bounds.origin
        origin.y = 0
        scrollView.setContentOffset(origin, animated: true)
    }

    func didMoveToBottom(on viewController: UIViewController) {
        var origin = self.view.bounds.origin
        origin.y = self.view.bounds.height - LiftNavigationController.navigationBarHeight
        scrollView.setContentOffset(origin, animated: true)
    }
}
