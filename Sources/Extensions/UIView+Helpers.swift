import UIKit

extension UILabel {

    public func width() -> CGFloat {
        let rect = (self.attributedText ?? NSAttributedString()).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        return rect.width
    }
}
