import UIKit
import Lift

class RootViewController: LiftNavigationController {
    override public init() {
        super.init()

        let topViewController = UIViewController()
        topViewController.view.backgroundColor = .white
        topViewController.view.layer.borderWidth = 5.0
        topViewController.view.layer.borderColor = UIColor.liftGreen().cgColor

        let firstViewController = UIViewController()
        firstViewController.title = "1st"
        firstViewController.view.backgroundColor = .white
        firstViewController.view.layer.borderWidth = 5.0
        firstViewController.view.layer.borderColor = UIColor.liftRed().cgColor

        let secondViewController = UIViewController()
        secondViewController.title = "2nd"
        secondViewController.view.backgroundColor = .white
        secondViewController.view.layer.borderWidth = 5.0
        secondViewController.view.layer.borderColor = UIColor.liftBlue().cgColor

        let thirdViewController = UIViewController()
        thirdViewController.title = "3th"
        thirdViewController.view.backgroundColor = .white
        thirdViewController.view.layer.borderWidth = 5.0
        thirdViewController.view.layer.borderColor = UIColor.liftPink().cgColor

        let fourthViewController = UIViewController()
        fourthViewController.title = "4th"
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
