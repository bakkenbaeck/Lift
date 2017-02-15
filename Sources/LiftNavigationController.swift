import UIKit

public class LiftNavigationController: UIViewController {
    public static let navigationBarHeight = CGFloat(64.0)

    public var topViewController: UIViewController

    var heightAnchor: NSLayoutConstraint?

    lazy var gestureRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer()
        recognizer.direction = .up
        recognizer.addTarget(self, action: #selector(self.didSwipe(_:)))

        return recognizer
    }()

    lazy var bottomScrollView: BottomScrollView = {
        let scrollView = BottomScrollView(parentController: self)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.viewDelegate = self

        return scrollView
    }()

    lazy var navigationBar: RoomIndicatorView = {

        let navigationBar = RoomIndicatorView()
        navigationBar.backgroundColor = .white
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.roomIndicatorDelegate = self

        return navigationBar
    }()

    public init(topViewController: UIViewController, bottomViewControllers: [UIViewController]) {
        self.topViewController = topViewController

        super.init(nibName: nil, bundle: nil)

        self.bottomScrollView.bottomViewControllers = bottomViewControllers
        self.navigationBar.roomTitles = bottomViewControllers.map{ controller in controller.title ?? ""}

        self.topViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(self.gestureRecognizer)
        self.addSubviewsAndConstraints()
    }

    func addSubviewsAndConstraints() {
        self.addChildViewController(self.topViewController)

        self.view.addSubview(self.topViewController.view)
        self.view.addSubview(self.navigationBar)
        self.view.addSubview(self.bottomScrollView)

        self.heightAnchor = self.topViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0)
        self.heightAnchor?.isActive = true

        self.topViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.topViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.topViewController.view.heightAnchor.constraint(equalToConstant: self.view.bounds.height - LiftNavigationController.navigationBarHeight).isActive = true

        self.navigationBar.topAnchor.constraint(equalTo: self.topViewController.view.bottomAnchor).isActive = true
        self.navigationBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.navigationBar.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.navigationBar.heightAnchor.constraint(equalToConstant: LiftNavigationController.navigationBarHeight).isActive = true

        self.bottomScrollView.topAnchor.constraint(equalTo: self.navigationBar.bottomAnchor).isActive = true
        self.bottomScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.bottomScrollView.widthAnchor.constraint(greaterThanOrEqualTo: self.view.widthAnchor).isActive = true
        self.bottomScrollView.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -LiftNavigationController.navigationBarHeight).isActive = true
    }

    func didSwipe(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.direction == .up {
            self.heightAnchor?.constant = -(self.view.bounds.height - LiftNavigationController.navigationBarHeight)
            self.gestureRecognizer.direction = .down
        } else {
            if recognizer.direction == .down {
                self.heightAnchor?.constant = 0.0
                self.gestureRecognizer.direction = .up
            }
        }
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseOut, .allowUserInteraction, .beginFromCurrentState], animations: {
            self.view.layoutIfNeeded()
        }, completion: { bool in
        })
    }
}

extension LiftNavigationController: RoomIndicatorViewDelegate {
    func selectItemAt(_ index: Int, onNavigationBar navigationBar: RoomIndicatorView) {
       self.bottomScrollView.showPage(at: index)
    }
}

extension LiftNavigationController: PaginatedScrollViewDelegate {
    func didMove(from fromIndex: Int, to toIndex: Int, on bottomScrollView: BottomScrollView) {
        self.navigationBar.highLightIndex(index: toIndex )
    }
}
