import UIKit

class RotatingButton: UIButton {

    private var rotationAnimation: CAAnimation? {
        return self.imageView?.layer.animation(forKey: "180DegreeRotationAnimation")
    }

    var percentageFilled: CGFloat = 0.0 {
        didSet {
            self.layoutSubviews()
        }
    }

    let imageMask = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false

        if let imageView = self.imageView {
            self.imageMask.backgroundColor = UIColor.red.withAlphaComponent(0.5).cgColor
            self.imageMask.contentsGravity = kCAGravityResize
            self.imageMask.needsDisplayOnBoundsChange = true

            imageView.layer.needsDisplayOnBoundsChange = true
            imageView.layer.addSublayer(self.imageMask)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        CATransaction.begin()
        CATransaction.disableActions()

        var newFrame = self.imageView!.bounds
        newFrame.origin.y = -(newFrame.height * (1.0 - self.percentageFilled))
        self.imageMask.frame = newFrame

        CATransaction.commit()
    }

//    override func draw(_ rect: CGRect) {
//        guard let image = self.imageView?.image else { return }
//
//        let context: CGContext = UIGraphicsGetCurrentContext()!
//
//        context.saveGState()
//
//        context.draw(image.cgImage!, in: rect)
//        // context.draw(self.imageMask, in: rect)
//
//        context.setBlendMode(.destinationIn)
//
//        context.fill(rect)
//
//        context.restoreGState()
//    }

    private func add180DegreesRotationAnimation() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = Double.pi
        rotateAnimation.duration = 1
        rotateAnimation.isCumulative = true

        self.imageView?.layer.speed = 0
        self.imageView?.layer.add(rotateAnimation, forKey: "180DegreeRotationAnimation")
    }

    func update180DegreesRotationAnimation(percentage: CGFloat) {
        if self.rotationAnimation == nil {
            self.add180DegreesRotationAnimation()
        }

        self.imageView?.layer.timeOffset = CFTimeInterval(max(0.0, percentage))
    }
    
}
