import UIKit
import Lift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.


        let topViewController = UIViewController()
        topViewController.view.backgroundColor = .darkGray

        let firstViewController = UIViewController()
        firstViewController.view.backgroundColor = .gray

        let secondViewController = UIViewController()
        secondViewController.view.backgroundColor = .lightGray

        let controller = LiftNavigationController(topViewController: topViewController, bottomViewControllers: [firstViewController, secondViewController])

        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { fatalError("Window not found") }

        window.rootViewController = controller

        window.makeKeyAndVisible()
        
        return true
    }
}
