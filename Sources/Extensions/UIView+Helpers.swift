import UIKit

extension UIView {

    func rotate180Degrees(duration: CFTimeInterval = 4.0, completionDelegate: CAAnimationDelegate? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = 0.5 * .pi
        rotateAnimation.duration = duration

        if let delegate = completionDelegate {
            rotateAnimation.delegate = delegate
        }

        self.layer.add(rotateAnimation, forKey: nil)
    }
}

extension UILabel {

    public func width() -> CGFloat {
        let rect = (self.attributedText ?? NSAttributedString()).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        return rect.width
    }
}
