import UIKit

protocol SwitchableRoomDelegate: class {
    func selectRoomNumber(_ room: Int)
}

extension SwitchableRoomDelegate where Self: SwitchableRoom {
    func selectRoom(_ room: Int) {
        self.setCurrentRoomNumber(room)
    }
}

protocol SwitchableRoom {
    weak var switchableRoomDelegate: SwitchableRoomDelegate? { get  set }
    var currentRoom: Int { get set }

    func setCurrentRoomNumber(_ room: Int)
}
