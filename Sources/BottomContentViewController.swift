import UIKit

public protocol BottomContentViewControllerDelegate: class {
     func requestToSwitchToTop(from bottomContentViewController: BottomContentViewController)
}

open class BottomContentViewController: UIViewController {
    open weak var bottomContentViewControllerDelegate: BottomContentViewControllerDelegate?
}
