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

    class func liftBrightGreen() -> UIColor {
        return UIColor(hex: "3EE68F")
    }

    class func liftGreen() -> UIColor {
        return UIColor(hex: "58D0A8")
    }

    class func liftBlue() -> UIColor {
        return UIColor(hex: "66A5FF")
    }

    class func liftPink() -> UIColor {
        return UIColor(hex: "FD87B6")
    }

    class func liftRed() -> UIColor {
        return UIColor(hex: "FC637D")
    }
}
