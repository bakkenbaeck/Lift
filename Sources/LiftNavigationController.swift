import UIKit

public class LiftNavigationController: UIViewController {
    public static let navigationBarHeight = CGFloat(64.0)

    enum Floor: Int {
        case top
        case bottom
    }
    public var topViewController: UIViewController

    var shouldEvaluatePageChange = false
    var currentFloor = Floor.top {
        didSet {
            var origin = self.view.bounds.origin
            switch self.currentFloor {
            case .top:
                origin.y = 0
            case .bottom:
                origin.y = self.view.bounds.height - LiftNavigationController.navigationBarHeight
            }

            scrollView.setContentOffset(origin, animated: true)
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
        scrollView.bounces = false

        return scrollView
    }()

    lazy var bottomScrollView: BottomScrollView = {
        let scrollView = BottomScrollView(parentController: self)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white

        return scrollView
    }()

    lazy var switchButton: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectSwitchButton), for: .touchUpInside)

        return button
    }()

    lazy var navigationBar: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: LiftNavigationController.navigationBarHeight)

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    public init(topViewController: UIViewController, bottomViewControllers: [UIViewController]) {
        self.topViewController = topViewController

        super.init(nibName: nil, bundle: nil)

        self.bottomScrollView.bottomViewControllers = bottomViewControllers

        self.topViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.addSubviewsAndConstraints()
    }

    func addSubviewsAndConstraints() {
        self.addChildViewController(self.topViewController)

        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.topViewController.view)
        self.scrollView.addSubview(self.navigationBar)
        self.navigationBar.addSubview(self.switchButton)
        self.scrollView.addSubview(self.bottomScrollView)

        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.scrollView.heightAnchor.constraint(greaterThanOrEqualTo: self.view.heightAnchor).isActive = true

        self.topViewController.view.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.topViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.topViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.topViewController.view.heightAnchor.constraint(equalToConstant: self.view.bounds.height - LiftNavigationController.navigationBarHeight).isActive = true

        self.navigationBar.topAnchor.constraint(equalTo: self.topViewController.view.bottomAnchor).isActive = true
        self.navigationBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.navigationBar.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.navigationBar.heightAnchor.constraint(equalToConstant: LiftNavigationController.navigationBarHeight).isActive = true

        self.switchButton.topAnchor.constraint(equalTo: self.navigationBar.topAnchor).isActive = true
        self.switchButton.leftAnchor.constraint(equalTo: self.navigationBar.leftAnchor).isActive = true
        self.switchButton.heightAnchor.constraint(equalTo: self.navigationBar.heightAnchor).isActive = true
        self.switchButton.widthAnchor.constraint(equalTo: self.navigationBar.heightAnchor).isActive = true

        self.bottomScrollView.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor).isActive = true
        self.bottomScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.bottomScrollView.widthAnchor.constraint(greaterThanOrEqualTo: self.view.widthAnchor).isActive = true
        self.bottomScrollView.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -LiftNavigationController.navigationBarHeight).isActive = true
        self.bottomScrollView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
    }

    func didSelectSwitchButton() {
        self.currentFloor = self.currentFloor == .top ? .bottom : .top
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
            let index = Int(floor((scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1)
            self.currentFloor = Floor(rawValue: index) ?? self.currentFloor
        }
    }
}
