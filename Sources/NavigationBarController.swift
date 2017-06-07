import UIKit

protocol HorizontallyScrollableDelegate: class {
    func viewController(_ viewController: UIViewController, didScrollTo horizontalPosition: Int)
}

class NavigationBarController: UIViewController {

    fileprivate let navigationLabelCollectionViewOffset: CGFloat = 14
    fileprivate let switchButtonOffsetBottom: CGFloat = 30
    fileprivate let switchButtonOffsetTop: CGFloat = 26

    weak var verticallySwitchableDelegate: VerticallySwitchableDelegate?
    weak var horizontallySwitchableDelegate: HorizontallySwitchableDelegate?

    var verticalPosition = VerticalPosition.top
    var horizontalPosition = 0

    var navigationLabels = [String]()
    var style: NavigationBarStyle

    lazy var switchButton: UIButton = {
        let button = UIButton()

        if let topImage = self.style.topImage {
            button.setImage(topImage, for: .normal)
        }

        button.imageEdgeInsets.top = self.switchButtonOffsetTop
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.didSelectSwitchButton), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .clear
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 5, right: 0)

        return button
    }()

    lazy var navigationLabelCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.minimumInteritemSpacing = self.style.spacing
        layout.minimumLineSpacing = self.style.spacing

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.isScrollEnabled = false
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast

        collectionView.contentInset = UIEdgeInsets(top: 0, left: self.style.spacing, bottom: 0, right: 0)

        collectionView.isUserInteractionEnabled = false

        return collectionView
    }()

    lazy var line: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor.lightGray

        return line
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

    init(style: NavigationBarStyle) {
        self.style = style
        super.init(nibName: nil, bundle: nil)

        self.navigationLabelCollectionView.delegate = self
        self.navigationLabelCollectionView.dataSource = self
        self.navigationLabelCollectionView.register(NavigationLabelCell.self, forCellWithReuseIdentifier: NavigationLabelCell.identifier)

        self.setCurrentHorizontalPosition(0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = .white

        self.addSubViewsAndConstraints()

        self.navigationLabelCollectionView.reloadData()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        //self.navigationLabelCollectionView.reloadData()
    }

    func addSubViewsAndConstraints() {
        self.view.addSubview(self.navigationLabelCollectionView)
        self.view.addSubview(self.switchButton)
        self.view.addSubview(self.line)

        self.view.addGestureRecognizer(self.swipeLeftRecognizer)
        self.view.addGestureRecognizer(self.swipeRightRecognizer)

        self.navigationLabelCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.navigationLabelCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        self.navigationLabelCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.navigationLabelCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true

        self.switchButton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.switchButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        self.switchButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true

        self.line.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.line.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.line.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }

    func didSelectSwitchButton() {
        self.setVerticalPosition(self.verticalPosition == .top ? .bottom : .top)
        self.verticallySwitchableDelegate?.didSwitchToPosition(self.verticalPosition, on: self)
    }

    func didSwipeRight(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            guard self.horizontalPosition > 0 else { return }
            self.setCurrentHorizontalPosition(self.horizontalPosition - 1)
        }
    }

    func didSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            guard self.horizontalPosition < (self.navigationLabels.count - 1) else { return }
            self.setCurrentHorizontalPosition(self.horizontalPosition + 1)
        }
    }
}

extension NavigationBarController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.navigationLabels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationLabelCell.identifier, for: indexPath) as! NavigationLabelCell

        cell.titleLabel.text = self.navigationLabels[indexPath.row]
        cell.titleLabel.font = self.style.font
        cell.titleLabel.textAlignment = .center

        if indexPath.row == self.horizontalPosition && self.verticalPosition == .bottom {
            cell.titleLabel.textColor = self.style.activeTextColor
        } else {
            cell.titleLabel.textColor = self.style.inactiveTextColor
        }

        return cell
    }
}

extension NavigationBarController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.setCurrentHorizontalPosition(indexPath.row)
    }

    func setCurrentHorizontalPosition(_ position: Int) {
        defer { self.horizontalPosition = position }
        guard self.navigationLabelCollectionView.numberOfItems(inSection: 0) > 0 else { return }

        let indexPath = IndexPath(item: position, section: 0)
        let cell = self.collectionView(self.navigationLabelCollectionView, cellForItemAt: indexPath)

        let padding = self.style.spacing
        let x = cell.frame.origin.x - padding
        let y = self.navigationLabelCollectionView.contentOffset.y
        let offset = CGPoint(x: x, y: y)

        self.navigationLabelCollectionView.setContentOffset(offset, animated: true)
        self.horizontallySwitchableDelegate?.viewController(self, didSelectPosition: position)
    }
}

extension NavigationBarController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: self.widthForItem(atIndex: indexPath.item), height: 44)
    }

    func widthForItem(atIndex index: Int) -> CGFloat {
        return self.estimateFrameForText(text: self.navigationLabels[index]).width + (self.style.spacing * 2)
    }

    func estimateFrameForText(text: String) -> CGRect {
        let width = CGFloat.greatestFiniteMagnitude

        let size = CGSize(width: width, height: self.view.frame.height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSFontAttributeName: self.style.font]

        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
}

extension NavigationBarController: VerticallySwitchable, VerticallySwitchableDelegate {

    func moveToTop() {
        self.navigationLabelCollectionView.isUserInteractionEnabled = false
        self.swipeLeftRecognizer.isEnabled = false
        self.swipeRightRecognizer.isEnabled = false

        self.switchButton.imageView?.rotate180Degrees(duration: 0.2, completionDelegate: self)

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
            self.navigationLabelCollectionView.contentOffset.y = self.navigationLabelCollectionViewOffset
            self.switchButton.imageEdgeInsets.top = -self.switchButtonOffsetTop
        }
    }

    func moveToBottom() {
        self.navigationLabelCollectionView.isUserInteractionEnabled = true
        self.swipeLeftRecognizer.isEnabled = true
        self.swipeRightRecognizer.isEnabled = true

        self.switchButton.imageView?.rotate180Degrees(duration: LiftNavigationController.switchAnimationDuration, completionDelegate: self)

        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.navigationLabelCollectionView.contentOffset.y = -self.navigationLabelCollectionViewOffset
            self.switchButton.imageEdgeInsets.top = self.switchButtonOffsetBottom
        }
    }

    func didSwipeToPosition(_ position: VerticalPosition, on viewController: UIViewController) {
        self.setVerticalPosition(position)
    }
}

extension NavigationBarController: HorizontallyScrollableDelegate {

    func viewController(_ viewController: UIViewController, didScrollTo horizontalPosition: Int) {
        if self.horizontalPosition != horizontalPosition {
            UIView.animate(withDuration: 0.2, delay: 0, options: [UIViewAnimationOptions.curveEaseOut, UIViewAnimationOptions.beginFromCurrentState], animations: {
                self.setCurrentHorizontalPosition(horizontalPosition)
            }, completion: { b in
                // self.navigationLabelCollectionView.reloadData()
            })
        }
    }
}

extension NavigationBarController: CAAnimationDelegate {

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if self.verticalPosition == .top {
            if let topImage = self.style.topImage {
                self.switchButton.setImage(topImage, for: .normal)
            }
        }
        if self.verticalPosition == .bottom {
            if let bottomImage = self.style.bottomImage {
                self.switchButton.setImage(bottomImage, for: .normal)
            }
        }
    }
}
