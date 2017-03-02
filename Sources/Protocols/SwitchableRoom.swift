import UIKit

protocol SwitchableRoomDelegate: class {
    func viewController(_ viewController: UIViewController, didScrollTo contentOffset: CGPoint)
}

//protocol SwitchableRoom: class {
//    weak var switchableRoomDelegate: SwitchableRoomDelegate? { get  set }
//    var currentRoom: Int { get set }
//
//    func setCurrentRoomNumber(_ room: Int)
//}