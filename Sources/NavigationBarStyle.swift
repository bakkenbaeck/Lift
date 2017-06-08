import UIKit

public struct NavigationBarStyle {
    var barImage: UIImage?
    var font: UIFont
    var activeTextColor: UIColor
    var inactiveTextColor: UIColor
    var spacing: CGFloat

    public init() {
        self.font = UIFont.systemFont(ofSize: 18)
        self.activeTextColor = .black
        self.inactiveTextColor = .gray
        self.spacing = CGFloat(40.0)
    }

    public init(barImage: UIImage, font: UIFont, activeTextColor: UIColor, inactiveTextColor: UIColor, spacing: CGFloat) {
        self.barImage = barImage
        self.font = font
        self.activeTextColor = activeTextColor
        self.inactiveTextColor = inactiveTextColor
        self.spacing = spacing
    }
}
