import UIKit

protocol RoomIndicatorCellDelegate: class {
    func didSwipeRight(on cell: RoomIndicatorCell)
    func didSwipeLeft(on cell: RoomIndicatorCell)
}

class RoomIndicatorCell: UICollectionViewCell {
    static let identifier = "roomIndicatorCellIdentifier"
    weak var delegate: RoomIndicatorCellDelegate?

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center

        return label
    }()

    lazy var swipeLeftRecognizer: UISwipeGestureRecognizer = {
       let gestureRecognizer = UISwipeGestureRecognizer()
        gestureRecognizer.direction = .left
        gestureRecognizer.addTarget(self, action: #selector(didSwipeLeft))

        return gestureRecognizer
    }()

    lazy var swipeRightRecognizer: UISwipeGestureRecognizer = {
       let gestureRecognizer = UISwipeGestureRecognizer()
        gestureRecognizer.direction = .right
        gestureRecognizer.addTarget(self, action: #selector(didSwipeRight))

        return gestureRecognizer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubviewsAndConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviewsAndConstraints() {
        self.addSubview(self.titleLabel)

        self.addGestureRecognizer(self.swipeLeftRecognizer)
        self.addGestureRecognizer(self.swipeRightRecognizer)

        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    func didSwipeRight() {
      self.delegate?.didSwipeRight(on: self)
    }

    func didSwipeLeft() {
        self.delegate?.didSwipeLeft(on: self)
    }
}
