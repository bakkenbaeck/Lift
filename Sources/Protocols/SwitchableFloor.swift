import UIKit

enum Floor: Int {
    case top
    case bottom
}

protocol SwitchableFloorDelegate: class {
    func didSwipeToFloor(_ floor: Floor, on viewController: UIViewController)
    func didNavigateToFloor(_ floor: Floor, on viewController: UIViewController)
}

extension SwitchableFloorDelegate where Self: SwitchableFloor {
    // make the methods optional
    func didSwipeToFloor(_ floor: Floor, on viewController: UIViewController) {}
    func didNavigateToFloor(_ floor: Floor, on viewController: UIViewController) {}
}

protocol SwitchableFloor: class {
    weak var switchableFloorDelegate: SwitchableFloorDelegate? { get set }

    var currentFloor: Floor { get set }
    func setCurrentFloor(_ floor: Floor)

    func moveToTop()
    func moveToBottom()
}

extension SwitchableFloor {

    func setCurrentFloor(_ floor: Floor) {
        guard self.currentFloor != floor else { return }

        if floor == .top {
            self.moveToTop()
        } else if floor == .bottom {
            self.moveToBottom()
        }
        self.currentFloor = floor
    }
}
