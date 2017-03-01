import UIKit

protocol RoomIndicatorViewDelegate: class {
   func selectItemAt(_ index: Int, onNavigationBar navigationBar: RoomIndicatorView)
}

class RoomIndicatorView: UICollectionView {
    static let itemWidth = CGFloat(100.0)
    static let leftMargin = (UIScreen.main.bounds.width - RoomIndicatorView.itemWidth) * 0.5

    weak var roomIndicatorDelegate: RoomIndicatorViewDelegate?

    var currentFloor = Floor.top {
        didSet {
            switch self.currentFloor {
            case .top:
                print("top")
            case .bottom:
                print("bottom")
            }
        }
    }

    var selectedRoomIndex = 0
    var roomTitles = [String]()

    init(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: RoomIndicatorView.itemWidth, height: LiftNavigationController.navigationBarHeight)
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumLineSpacing = 0.0

        super.init(frame: CGRect.zero, collectionViewLayout: layout)

        self.delegate = self
        self.dataSource = self
        self.register(RoomIndicatorCell.self, forCellWithReuseIdentifier: RoomIndicatorCell.identifier)

        self.isScrollEnabled = false
        self.isPagingEnabled = true
        self.scrollsToTop = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.decelerationRate = UIScrollViewDecelerationRateFast
        self.contentInset = UIEdgeInsetsMake(0, RoomIndicatorView.leftMargin, 0, 0)
        self.highLightIndex(index: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func highLightIndex(index: Int) {
        self.selectedRoomIndex = index
        self.setContentOffset(CGPoint(x: (CGFloat(index) * RoomIndicatorView.itemWidth) - RoomIndicatorView.leftMargin, y:0), animated: true)
        self.reloadData()
    }
}

extension RoomIndicatorView: UICollectionViewDelegate, UICollectionViewDataSource {
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
