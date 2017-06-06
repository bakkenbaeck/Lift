import UIKit

enum VerticalPosition: Int {
    case top
    case bottom
}

protocol VerticallySwitchableDelegate: class {
    func didSwipeToPosition(_ position: VerticalPosition, on viewController: UIViewController)
    func didSwitchToPosition(_ position: VerticalPosition, on viewController: UIViewController)
}

extension VerticallySwitchableDelegate where Self: VerticallySwitchable {
    // make the methods optional
    func didSwipeToPosition(_ position: VerticalPosition, on viewController: UIViewController) {}
    func didSwitchToPosition(_ position: VerticalPosition, on viewController: UIViewController) {}
}

protocol VerticallySwitchable: class {
    weak var verticallySwitchableDelegate: VerticallySwitchableDelegate? { get set }

    var verticalPosition: VerticalPosition { get set }
    func setVerticalPosition(_ position: VerticalPosition)

    func moveToTop()
    func moveToBottom()
}

extension VerticallySwitchable {

    func setVerticalPosition(_ position: VerticalPosition) {
        guard self.verticalPosition != position else { return }

        switch position {
        case .top:
            self.moveToTop()
        case .bottom:
            self.moveToBottom()
        }
        
        self.verticalPosition = position
    }
}
