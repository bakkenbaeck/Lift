import UIKit

public protocol BottomControllerDelegate: class {
     func requestToSwitchToTop(from bottomController: BottomController)
}

open class BottomController: UIViewController {
    open weak var bottomControllerDelegate: BottomControllerDelegate?
}
