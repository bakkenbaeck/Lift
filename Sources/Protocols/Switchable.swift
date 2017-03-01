import UIKit

enum Floor: Int {
    case top
    case bottom
}

protocol Switchable: class {
    var currentFloor: Floor { get set }
    func setCurrentFloor(_ floor: Floor, onViewController viewController: UIViewController)

    func didMoveToTop(on viewController: UIViewController)
    func didMoveToBottom(on viewController: UIViewController)
}

extension Switchable where Self: UIViewController {
    func setCurrentFloor(_ floor: Floor, onViewController viewController: UIViewController) {
        if floor == .top {
            self.didMoveToTop(on: self)
        } else if floor == .bottom {
            self.didMoveToBottom(on: self)
        }
        self.currentFloor = floor
    }
}