import UIKit

protocol SwitchableRoomDelegate: class {
    func selectRoomNumber(_ room: Int)
}

extension SwitchableRoomDelegate where Self: SwitchableRoom {
    func selectRoomNumber(_ room: Int) {
        self.setCurrentRoomNumber(room)
    }
}

protocol SwitchableRoom: class {
    weak var switchableRoomDelegate: SwitchableRoomDelegate? { get  set }
    var currentRoom: Int { get set }

    func setCurrentRoomNumber(_ room: Int) 
}