import UIKit

protocol NavigationBarDelegate: class {
   func selectItemAt(_ index: Int, onNavigationBar navigationBar: NavigationBar)
}

class NavigationBar: UICollectionView {
    static let itemWidth = CGFloat(100.0)
    static let leftMargin = (UIScreen.main.bounds.width - NavigationBar.itemWidth) * 0.5

    weak var barDelegate: NavigationBarDelegate?

    var selectedItemIndex = 0
    var titles = [String]()

    init(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: NavigationBar.itemWidth, height: LiftNavigationController.navigationBarHeight)
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumLineSpacing = 0.0

        super.init(frame: CGRect.zero, collectionViewLayout: layout)

        self.delegate = self
        self.dataSource = self
        self.register(NavigationCell.self, forCellWithReuseIdentifier: NavigationCell.identifier)

        self.isScrollEnabled = false
        self.isPagingEnabled = true
        self.scrollsToTop = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.decelerationRate = UIScrollViewDecelerationRateFast
        self.contentInset = UIEdgeInsetsMake(0, NavigationBar.leftMargin, 0, 0)
        self.highLightIndex(index: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func highLightIndex(index: Int) {
        self.selectedItemIndex = index
        self.setContentOffset(CGPoint(x: (CGFloat(index) * NavigationBar.itemWidth) - NavigationBar.leftMargin, y:0), animated: true)
        self.reloadData()
    }
}

extension NavigationBar: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return titles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationCell.identifier, for: indexPath) as! NavigationCell
        cell.titleLabel.text = self.titles[indexPath.row]
        if indexPath.row == self.selectedItemIndex {
            cell.titleLabel.textColor = .black
        } else {
            cell.titleLabel.textColor = .gray
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       self.barDelegate?.selectItemAt(indexPath.row, onNavigationBar: self)
    }
}
