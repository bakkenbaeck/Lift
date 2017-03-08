import UIKit

protocol ScrollableRoomDelegate: class {
    func viewController(_ viewController: UIViewController, didScrollTo contentOffset: CGPoint)
}

class RoomIndicatorController: UIViewController {
    static let itemWidth = CGFloat(100.0)
    static let buttonWidth = CGFloat(64.0)

    weak var switchableFloorDelegate: SwitchableFloorDelegate?
    weak var switchableRoomDelegate: SwitchableRoomDelegate?

    var currentFloor = Floor.top
    var currentRoom = 0

    var roomTitles = [String]()

    var font: UIFont?
    var buttonImage: UIImage?

    var switchButtonWidthAnchor: NSLayoutConstraint?

    lazy var switchButton: UIButton = {
        let button = UIButton()

        button.setImage(self.buttonImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectSwitchButton), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .clear
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 0, 0)

        return button
    }()

    lazy var roomCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: RoomIndicatorController.itemWidth, height: LiftNavigationController.navigationBarHeight)
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumLineSpacing = 0.0

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)

        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.isScrollEnabled = false
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast

        collectionView.isUserInteractionEnabled = false

        return collectionView
    }()

    lazy var swipeLeftRecognizer: UISwipeGestureRecognizer = {
        let gestureRecognizer = UISwipeGestureRecognizer()
        gestureRecognizer.direction = .left
        gestureRecognizer.addTarget(self, action: #selector(didSwipeLeft))
        gestureRecognizer.isEnabled = false

        return gestureRecognizer
    }()

    lazy var swipeRightRecognizer: UISwipeGestureRecognizer = {
        let gestureRecognizer = UISwipeGestureRecognizer()
        gestureRecognizer.direction = .right
        gestureRecognizer.addTarget(self, action: #selector(didSwipeRight))
        gestureRecognizer.isEnabled = false

        return gestureRecognizer
    }()

    init() {
        super.init(nibName: nil, bundle: nil)

        self.roomCollectionView.delegate = self
        self.roomCollectionView.dataSource = self
        self.roomCollectionView.register(RoomIndicatorCell.self, forCellWithReuseIdentifier: RoomIndicatorCell.identifier)

        self.setCurrentRoomNumber(0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = .white

        self.addSubViewsAndConstraints()
    }

    func addSubViewsAndConstraints() {
        self.view.addSubview(self.switchButton)
        self.view.addSubview(self.roomCollectionView)

        self.view.addGestureRecognizer(self.swipeLeftRecognizer)
        self.view.addGestureRecognizer(self.swipeRightRecognizer)

        self.switchButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.switchButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.switchButton.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        self.switchButtonWidthAnchor = self.switchButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width)
        self.switchButtonWidthAnchor?.isActive = true

        self.roomCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.roomCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: RoomIndicatorController.buttonWidth).isActive = true
        self.roomCollectionView.widthAnchor.constraint(equalToConstant: self.view.bounds.width - RoomIndicatorController.buttonWidth).isActive = true
        self.roomCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
    }

    func didSelectSwitchButton() {
        self.setCurrentFloor(self.currentFloor == .top ? .bottom : .top)
        self.switchableFloorDelegate?.didNavigateToFloor(self.currentFloor, on: self)
    }

    func didSwipeRight() {
        guard self.currentRoom > 0 else { return }
        self.setCurrentRoomNumber(self.currentRoom - 1)
    }

    func didSwipeLeft() {
        guard self.currentRoom < (self.roomTitles.count - 1) else { return }
        self.setCurrentRoomNumber(self.currentRoom + 1)
    }
}

extension RoomIndicatorController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomTitles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoomIndicatorCell.identifier, for: indexPath) as! RoomIndicatorCell

        cell.titleLabel.text = self.roomTitles[indexPath.row]
        cell.titleLabel.font = self.font ?? UIFont.systemFont(ofSize: 18)
        if indexPath.row == self.currentRoom {
            cell.titleLabel.textColor = .black
        } else {
            cell.titleLabel.textColor = .gray
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.setCurrentRoomNumber(indexPath.row)
    }

    func setCurrentRoomNumber(_ room: Int) {
        self.currentRoom = room
        self.roomCollectionView.setContentOffset(CGPoint(x: RoomIndicatorController.itemWidth * CGFloat(room), y: 0), animated: true)
        self.roomCollectionView.reloadData()
        self.switchableRoomDelegate?.viewController(self, didSelectRoom: room)
    }
}

extension RoomIndicatorController: SwitchableFloor, SwitchableFloorDelegate {

    func moveToTop() {
        self.roomCollectionView.isUserInteractionEnabled = false
        self.swipeLeftRecognizer.isEnabled = false
        self.swipeRightRecognizer.isEnabled = false

        self.switchButtonWidthAnchor?.constant = self.view.bounds.width
        self.view.setNeedsLayout()
    }

    func moveToBottom() {
        self.roomCollectionView.isUserInteractionEnabled = true
        self.swipeLeftRecognizer.isEnabled = true
        self.swipeRightRecognizer.isEnabled = true

        self.switchButtonWidthAnchor?.constant = RoomIndicatorController.buttonWidth
        self.view.setNeedsLayout()
    }

    func didSwipeToFloor(_ floor: Floor, on viewController: UIViewController) {
        self.setCurrentFloor(floor)
    }
}

extension RoomIndicatorController: ScrollableRoomDelegate {

    func viewController(_ viewController: UIViewController, didScrollTo contentOffset: CGPoint) {
        guard let bottomController = viewController as? BottomController else { return }
        guard contentOffset.x >= 0 else { return }

        let scrollPercentage = bottomController.scrollView.contentSize.width / contentOffset.x
        let xOffsetForRoomIndicatorController = self.roomCollectionView.contentSize.width / scrollPercentage
        let newContentOffset = CGPoint(x: xOffsetForRoomIndicatorController, y: 0)

        var scrollBounds = self.roomCollectionView.bounds
        scrollBounds.origin = newContentOffset

        self.currentRoom = self.roomCollectionView.indexPathForItem(at: newContentOffset)?.row ?? self.currentRoom
        UIView.animate(withDuration: 0.2, animations: {
            self.roomCollectionView.bounds = scrollBounds
        }, completion: { b in
            self.roomCollectionView.reloadData()
        })
    }
}
