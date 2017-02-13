import UIKit
import Lift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let controller = LiftNavigationController(topViewController: UIViewController(), bottomViewControllers: [UIViewController]())

        return true
    }
}

