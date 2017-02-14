import UIKit
import Lift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let topViewController = UIViewController()
        topViewController.view.backgroundColor = .white
        topViewController.view.layer.borderWidth = 5.0
        topViewController.view.layer.borderColor = UIColor.liftGreen().cgColor

        let firstViewController = UIViewController()
        firstViewController.view.backgroundColor = .white
        firstViewController.view.layer.borderWidth = 5.0
        firstViewController.view.layer.borderColor = UIColor.liftRed().cgColor

        let secondViewController = UIViewController()
        secondViewController.view.backgroundColor = .white
        secondViewController.view.layer.borderWidth = 5.0
        secondViewController.view.layer.borderColor = UIColor.liftBlue().cgColor

        let thirdViewController = UIViewController()
        thirdViewController.view.backgroundColor = .white
        thirdViewController.view.layer.borderWidth = 5.0
        thirdViewController.view.layer.borderColor = UIColor.liftPink().cgColor

        let controller = LiftNavigationController(topViewController: topViewController, bottomViewControllers: [firstViewController, secondViewController, thirdViewController])

        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { fatalError("Window not found") }

        window.rootViewController = controller

        window.makeKeyAndVisible()

        return true
    }
}
