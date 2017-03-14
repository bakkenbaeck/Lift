import UIKit

public struct NavigationBarStyle {
    var bottomImage: UIImage?
    var topImage: UIImage?
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

    public init(bottomImage: UIImage, topImage: UIImage, font: UIFont, activeTextColor: UIColor, inactiveTextColor: UIColor, spacing: CGFloat) {
        self.bottomImage = bottomImage
        self.topImage = topImage
        self.font = font
        self.activeTextColor = activeTextColor
        self.inactiveTextColor = inactiveTextColor
        self.spacing = spacing
    }
}