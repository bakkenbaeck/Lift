import UIKit
import Lift

class RootViewController: LiftNavigationController {

    public init() {
        let style = NavigationBarStyle(bottomImage: UIImage(named: "switch-button-up")!, topImage: UIImage(named: "switch-button-down")!, font: UIFont.systemFont(ofSize: 18), activeTextColor: .liftBlue(), inactiveTextColor: .lightGray, spacing: 20)

        super.init(navigationBarStyle: style)

        let topViewController = UIViewController()
        topViewController.view.backgroundColor = .white
        topViewController.view.layer.borderWidth = 5.0
        topViewController.view.layer.borderColor = UIColor.liftGreen().cgColor

        let firstViewController = TableController()
        firstViewController.title = "First"

        let secondViewController = TableController()
        secondViewController.title = "Second"
        secondViewController.view.backgroundColor = .white
        secondViewController.view.layer.borderWidth = 5.0
        secondViewController.view.layer.borderColor = UIColor.liftBlue().cgColor

        let thirdViewController = TableController()
        thirdViewController.title = "Third"
        thirdViewController.view.backgroundColor = .white
        thirdViewController.view.layer.borderWidth = 5.0
        thirdViewController.view.layer.borderColor = UIColor.liftPink().cgColor

        let fourthViewController = TableController()
        fourthViewController.title = "Fourth"
        fourthViewController.view.backgroundColor = .white
        fourthViewController.view.layer.borderWidth = 5.0
        fourthViewController.view.layer.borderColor = UIColor.liftBrightGreen().cgColor

        self.topViewController = topViewController
        self.bottomViewControllers = [firstViewController, secondViewController, thirdViewController, fourthViewController]

        self.view.translatesAutoresizingMaskIntoConstraints = false
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
