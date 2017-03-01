import UIKit

enum Floor: Int {
    case top
    case bottom
}

protocol SwitchableFloorDelegate: class {
    func selectFloor(_ floor: Floor)
}

extension SwitchableFloorDelegate where Self: SwitchableFloor {
    func selectFloor(_ floor: Floor) {
      self.setCurrentFloor(floor)
    }
}
protocol SwitchableFloor: class {
   weak var switchableFloorDelegate: SwitchableFloorDelegate? { get  set }

    var currentFloor: Floor { get set }
    func setCurrentFloor(_ floor: Floor)

    func didMoveToTop()
    func didMoveToBottom()
}

extension SwitchableFloor {
    func setCurrentFloor(_ floor: Floor) {
        if floor == .top {
            self.didMoveToTop()
        } else if floor == .bottom {
            self.didMoveToBottom()
        }
        self.currentFloor = floor
        self.switchableFloorDelegate?.selectFloor(floor)
    }
}