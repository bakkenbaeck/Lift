import UIKit
import Lift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    lazy var liftController: LiftNavigationController = {
        let topViewController = UIViewController()
        topViewController.view.backgroundColor = .darkGray

        let firstCardViewController = UIViewController()
        firstCardViewController.view.backgroundColor = .gray
        firstCardViewController.title = "First card"
        let secondCardViewController = UIViewController()
        secondCardViewController.view.backgroundColor = .lightGray
        secondCardViewController.title = "Second card"

        let liftController = LiftNavigationController(topViewController: topViewController, bottomViewControllers: [firstCardViewController, secondCardViewController])

        return liftController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { fatalError("Window not found") }

        window.makeKeyAndVisible()

        return true
    }
}

