import UIKit

class RoomIndicatorController: UIViewController {
    static let itemWidth = CGFloat(100.0)
    static let leftMargin = (UIScreen.main.bounds.width - RoomIndicatorController.itemWidth) * 0.5

    weak var switchableFloorDelegate: SwitchableFloorDelegate?

    lazy var switchButton: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectSwitchButton), for: .touchUpInside)

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
        collectionView.contentInset = UIEdgeInsetsMake(0, RoomIndicatorController.leftMargin, 0, 0)

        return collectionView
    }()

    var currentFloor = Floor.top
  
    var selectedRoomIndex = 0
    var roomTitles = [String]()

    init(){
        super.init(nibName: nil, bundle: nil)

        self.roomCollectionView.delegate = self
        self.roomCollectionView.dataSource = self
        self.roomCollectionView.register(RoomIndicatorCell.self, forCellWithReuseIdentifier: RoomIndicatorCell.identifier)

        self.highLightIndex(index: 0)
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

        self.switchButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.switchButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.switchButton.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        self.switchButton.widthAnchor.constraint(equalToConstant: 44).isActive = true

        self.roomCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.roomCollectionView.leftAnchor.constraint(equalTo: self.switchButton.rightAnchor).isActive = true
        self.roomCollectionView.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 44).isActive = true
        self.roomCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
    }

    func highLightIndex(index: Int) {
        self.selectedRoomIndex = index
        self.roomCollectionView.setContentOffset(CGPoint(x: (CGFloat(index) * RoomIndicatorController.itemWidth) - RoomIndicatorController.leftMargin, y:0), animated: true)
        self.roomCollectionView.reloadData()
    }

    func didSelectSwitchButton() {
        self.setCurrentFloor(self.currentFloor == .top ? .bottom : .top)
    }
}

extension RoomIndicatorController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return roomTitles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoomIndicatorCell.identifier, for: indexPath) as! RoomIndicatorCell
        cell.titleLabel.text = self.roomTitles[indexPath.row]
        if indexPath.row == self.selectedRoomIndex {
            cell.titleLabel.textColor = .black
        } else {
            cell.titleLabel.textColor = .gray
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//       self.roomIndicatorDelegate?.selectItemAt(indexPath.row)
    }
}

extension RoomIndicatorController: SwitchableFloor {
    func didMoveToTop() {
        self.switchableFloorDelegate?.selectFloor(self.currentFloor)
    }

    func didMoveToBottom() {
        self.switchableFloorDelegate?.selectFloor(self.currentFloor)
    }
}
