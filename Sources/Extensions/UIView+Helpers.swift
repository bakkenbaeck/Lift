import UIKit

extension UIView {

    public convenience init(withAutoLayout autoLayout: Bool) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = !autoLayout
    }
}
