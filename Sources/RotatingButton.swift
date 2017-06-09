import UIKit

public extension UIColor {

    public convenience init(hex: String) {
        let noHashString = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: noHashString)
        scanner.charactersToBeSkipped = CharacterSet.symbols

        var hexInt: UInt32 = 0
        if (scanner.scanHexInt32(&hexInt)) {
            let red = (hexInt >> 16) & 0xFF
            let green = (hexInt >> 8) & 0xFF
            let blue = (hexInt) & 0xFF

            self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
        } else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
    }
}

class RotatingButton: UIButton {

    private var rotationAnimation: CAAnimation? {
        return self.imageView?.layer.animation(forKey: "180DegreeRotationAnimation")
    }

    var percentageFilled: CGFloat = 0.0 {
        didSet {
            self.updateFrames()
        }
    }

    let lightMask: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(hex: "E7E7F0")

        return view
    }()

    let darkMask: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(hex: "222233")

        view.transform = CGAffineTransform(rotationAngle: .pi)
        view.layer.anchorPoint = CGPoint(x: 0.5, y: 0)

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false

        if let imageView = self.imageView {
            self.insertSubview(self.lightMask, belowSubview: imageView)
            self.insertSubview(self.darkMask, belowSubview: imageView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.updateFrames()
    }

    private func updateFrames() {
        var newFrame = self.imageView!.frame

        newFrame.origin.y += 1
        newFrame.origin.x += 1
        newFrame.size.width -= 1
        newFrame.size.height -= 1

        self.lightMask.frame = newFrame

        newFrame.origin.y += newFrame.size.height
        newFrame.size.height *= self.percentageFilled
        self.darkMask.frame = newFrame
    }

    private func add180DegreesRotationAnimation() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = Double.pi
        rotateAnimation.duration = 0.999999999999
        rotateAnimation.isCumulative = true

        self.imageView?.layer.speed = 0
        self.imageView?.layer.add(rotateAnimation, forKey: "180DegreeRotationAnimation")

        self.lightMask.layer.speed = 0
        self.lightMask.layer.add(rotateAnimation, forKey: "180DegreeRotationAnimation")
    }

    func update180DegreesRotationAnimation(percentage: CGFloat) {
        if self.rotationAnimation == nil {
            self.add180DegreesRotationAnimation()
        }

        self.imageView?.layer.timeOffset = CFTimeInterval(max(0.0, percentage))
        self.lightMask.layer.timeOffset = CFTimeInterval(max(0.0, percentage))

        self.darkMask.isHidden = percentage < 1.0
    }
    
}
