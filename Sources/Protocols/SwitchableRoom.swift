import UIKit

protocol SwitchableRoomDelegate: class {
    func viewController(_ viewController: UIViewController, didSelectRoom room: Int)
}


protocol ScrollableRoomDelegate: class {
    func viewController(_ viewController: UIViewController, didScrollTo contentOffset: CGPoint)
}

