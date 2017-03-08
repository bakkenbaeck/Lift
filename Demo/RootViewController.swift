import UIKit
import Lift

class RootViewController: LiftNavigationController {

    public init() {
        super.init(nibName: nil, bundle: nil)

        let topViewController = UIViewController()
        topViewController.view.backgroundColor = .white
        topViewController.view.layer.borderWidth = 5.0
        topViewController.view.layer.borderColor = UIColor.liftGreen().cgColor

        let firstViewController = TableController()
        firstViewController.title = "First"
        firstViewController.view.backgroundColor = .white
        firstViewController.view.layer.borderWidth = 5.0
        firstViewController.view.layer.borderColor = UIColor.liftRed().cgColor

        let secondViewController = TableController()
        secondViewController.title = "Second" 
        secondViewController.view.backgroundColor = .white
        secondViewController.view.layer.borderWidth = 5.0
        secondViewController.view.layer.borderColor = UIColor.liftBlue().cgColor

        let thirdViewController = BottomController()
        thirdViewController.title = "Third"
        thirdViewController.view.backgroundColor = .white
        thirdViewController.view.layer.borderWidth = 5.0
        thirdViewController.view.layer.borderColor = UIColor.liftPink().cgColor

        let fourthViewController = BottomController()
        fourthViewController.title = "Fourth"
        fourthViewController.view.backgroundColor = .white
        fourthViewController.view.layer.borderWidth = 5.0
        fourthViewController.view.layer.borderColor = UIColor.liftBrightGreen().cgColor

        self.navigationBarFont = UIFont.systemFont(ofSize: 18)
        self.topBarButtonImage = UIImage(named: "switch-button-down")
        self.bottomBarButtonImage = UIImage(named: "switch-button-up")

        self.topViewController = topViewController
        self.bottomViewControllers = [firstViewController, secondViewController, thirdViewController, fourthViewController]

        self.view.translatesAutoresizingMaskIntoConstraints = false
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
