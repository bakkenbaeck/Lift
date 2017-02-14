import UIKit
import Lift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.


        let topViewController = UIViewController()
        topViewController.view.backgroundColor = .white
        topViewController.view.layer.borderWidth = 1.0
        topViewController.view.layer.borderColor = UIColor.kronGreen().cgColor

        let firstViewController = UIViewController()
        firstViewController.view.backgroundColor = .white
        firstViewController.view.layer.borderWidth = 1.0
        firstViewController.view.layer.borderColor = UIColor.kronRed().cgColor

        let secondViewController = UIViewController()
        secondViewController.view.backgroundColor = .white
        secondViewController.view.layer.borderWidth = 1.0
        secondViewController.view.layer.borderColor = UIColor.kronPink().cgColor

        let controller = LiftNavigationController(topViewController: topViewController, bottomViewControllers: [firstViewController, secondViewController])

        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { fatalError("Window not found") }

        window.rootViewController = controller

        window.makeKeyAndVisible()
        
        return true
    }
}
