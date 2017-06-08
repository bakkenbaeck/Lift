import UIKit

extension UIView {

    private var rotationAnimation: CAAnimation? {
        return self.layer.animation(forKey: "180DegreeRotationAnimation")
    }

    private func add180DegreesRotationAnimation() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = Double.pi
        rotateAnimation.duration = 1.0
        rotateAnimation.isCumulative = true

        self.layer.speed = 0
        self.layer.add(rotateAnimation, forKey: "180DegreeRotationAnimation")
    }

    func update180DegreesRotationAnimation(percentage: CGFloat) {
        if self.rotationAnimation == nil {
            self.add180DegreesRotationAnimation()
        }

        self.layer.timeOffset = CFTimeInterval(max(0.0, percentage))
    }
}

extension UILabel {

    public func width() -> CGFloat {
        let rect = (self.attributedText ?? NSAttributedString()).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        return rect.width
    }
}
