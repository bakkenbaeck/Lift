import UIKit

public protocol BottomControllerDelegate: class {
    func requestToSwitchToTop(from bottomController: BottomControllable)
}

public protocol PullToNavigateUpDelegate: class {
    func didUpdatePullToNavigateUpThreshold(percentage: CGFloat)
}

public protocol BottomControllable: class {
    weak var bottomControllerDelegate: BottomControllerDelegate? { get set }

    weak var pullToNavigateDelegate: PullToNavigateUpDelegate? { get set }

    var controllerTitle: String? { get set }

    var defaultView: UIView { get set }
}

public extension BottomControllable where Self: UIViewController {
    var controllerTitle: String? {
        get { return self.title }
        set(new) { /* do nothing */ }
    }

    var defaultView: UIView {
        get { return self.view }
        set(new) { /* do nothing */ }
    }
}
