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

    typealias VoidBlock = (Void) -> Void

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

    private var rotationAnimator: UIViewPropertyAnimator!

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false

        if let imageView = self.imageView {
            self.insertSubview(self.lightMask, belowSubview: imageView)
            self.insertSubview(self.darkMask, belowSubview: imageView)
        }

        self.rotationAnimator = UIViewPropertyAnimator(duration: 1.0, curve: .easeInOut) {
            let transform180 = CGAffineTransform(rotationAngle: .pi)

            self.imageView?.transform = transform180
            self.lightMask.transform = transform180
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

    func update180DegreesRotationAnimation(percentage: CGFloat) {
        self.rotationAnimator.fractionComplete = percentage
    }
    
}
