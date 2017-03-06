import UIKit

enum Floor: Int {
    case top
    case bottom
}

protocol SwitchableFloorDelegate: class {
    func didSwipeToFloor(_ floor: Floor, on viewController: LiftNavigationController)
    func didNavigateToFloor(_ floor: Floor, on viewController: RoomIndicatorController)
}

extension SwitchableFloorDelegate where Self: SwitchableFloor {
    // make the methods optional
    func didSwipeToFloor(_ floor: Floor, on viewController: LiftNavigationController) {}
    func didNavigateToFloor(_ floor: Floor, on viewController: RoomIndicatorController) {}
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
        if floor == .top {
            self.moveToTop()
        } else if floor == .bottom {
            self.moveToBottom()
        }
        self.currentFloor = floor
    }
}
