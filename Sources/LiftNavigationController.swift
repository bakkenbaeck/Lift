import UIKit

public class LiftNavigationController: UIViewController {
    public static let navigationBarHeight = CGFloat(44.0)

    public var topViewController: UIViewController

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = false

        return scrollView
    }()

    lazy var bottomScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white

        return scrollView
    }()

    var bottomViewControllers: [UIViewController]

    lazy var navigationBar: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: LiftNavigationController.navigationBarHeight)

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    public init(topViewController: UIViewController, bottomViewControllers: [UIViewController]) {
        self.topViewController = topViewController
        self.bottomViewControllers = bottomViewControllers

        super.init(nibName: nil, bundle: nil)

        self.topViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()


        self.addSubviewsAndConstraints()
    }

    func addSubviewsAndConstraints() {
        self.addChildViewController(self.topViewController)

        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.topViewController.view)
        self.scrollView.addSubview(self.navigationBar)
        self.scrollView.addSubview(self.bottomScrollView)

        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.scrollView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true

        self.topViewController.view.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.topViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.topViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.topViewController.view.heightAnchor.constraint(equalToConstant: self.view.bounds.height - LiftNavigationController.navigationBarHeight).isActive = true

        self.navigationBar.topAnchor.constraint(equalTo: self.topViewController.view.bottomAnchor).isActive = true
        self.navigationBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.navigationBar.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.navigationBar.heightAnchor.constraint(equalToConstant: LiftNavigationController.navigationBarHeight).isActive = true

        self.bottomScrollView.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor).isActive = true
        self.bottomScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.bottomScrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.bottomScrollView.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -LiftNavigationController.navigationBarHeight).isActive = true
        self.bottomScrollView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
    }
}
