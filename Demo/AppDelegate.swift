import UIKit
import Lift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var navigationController: UINavigationController = {
        let rootViewController = RootViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)

        navigationController.isNavigationBarHidden = true
        navigationController.navigationBar.barStyle = .black

        return navigationController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { fatalError("Window not found") }

        window.rootViewController = self.navigationController

        window.makeKeyAndVisible()

        return true
    }
}
