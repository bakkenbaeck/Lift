import UIKit

protocol RoomIndicatorViewDelegate: class {
   func selectItemAt(_ index: Int, onNavigationBar navigationBar: RoomIndicatorController)
}

class RoomIndicatorController: UIViewController {
    static let itemWidth = CGFloat(100.0)
    static let leftMargin = (UIScreen.main.bounds.width - RoomIndicatorController.itemWidth) * 0.5

    weak var roomIndicatorDelegate: RoomIndicatorViewDelegate?

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

    func highLightIndex(index: Int) {
        self.selectedRoomIndex = index
        self.roomCollectionView.setContentOffset(CGPoint(x: (CGFloat(index) * RoomIndicatorController.itemWidth) - RoomIndicatorController.leftMargin, y:0), animated: true)
        self.roomCollectionView.reloadData()
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
       self.roomIndicatorDelegate?.selectItemAt(indexPath.row, onNavigationBar: self)
    }
}

extension RoomIndicatorController: Switchable {
    func didMoveToTop(on viewController: UIViewController) {

    }

    func didMoveToBottom(on viewController: UIViewController) {

    }
}
