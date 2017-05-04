import UIKit

public protocol BottomControllerDelegate: class {
    func requestToSwitchToTop(from bottomController: BottomControllable)
    func requestToScrollOnTop(toYOffset yOffset: CGFloat, from bottomController: BottomControllable)
}

public protocol BottomControllable: class {
    func enableScrollView()

    weak var bottomControllerDelegate: BottomControllerDelegate? { get set }
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
