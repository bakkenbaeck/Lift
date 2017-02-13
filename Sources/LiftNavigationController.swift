import UIKit

public class LiftNavigationController: UIViewController {
    static let navigationBarHeight = CGFloat(44.0)

    public var topViewController: UIViewController
    public var bottomScrollView: UIScrollView

    public var bottomViewControllers: [UIViewController]

    public var navigationBar: UICollectionView

    public init(topViewController: UIViewController, bottomViewControllers: [UIViewController]) {
        self.topViewController = topViewController
        self.bottomViewControllers = bottomViewControllers

        self.navigationBar.backgroundColor = .black

        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSubviewsAndConstraints()
    }

    func addSubviewsAndConstraints() {
        self.addChildViewController(self.topViewController)
        self.addChildViewController(self.navigationController)
        self.addChildViewController(self.bottomScrollView)

        self.view.addSubview(self.topViewController)
        self.view.addSubview(self.navigationController)
        self.view.addSubview(self.bottomScrollView)

        self.topViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.topViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.topViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.topViewController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -LiftNavigationController.navigationBarHeight).isActive = true

        self.navigationBar.view.topAnchor.constraint(equalTo: self.topViewController.view.bottomAnchor).isActive = true
        self.navigationBar.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.navigationBar.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.navigationBar.view.heightAnchor.constraint(equalToConstant: LiftNavigationController.navigationBarHeight).isActive = true

        self.bottomScrollView.view.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor).isActive = true
        self.bottomScrollView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.bottomScrollView.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.bottomScrollView.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -LiftNavigationController.navigationBarHeight).isActive = true
    }
}
