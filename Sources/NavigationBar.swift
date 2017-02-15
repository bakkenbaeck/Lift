import UIKit

protocol NavigationBarDelegate: class {
   func selectItemAt(_ index: Int, onNavigationBar navigationBar: NavigationBar)
}

class NavigationBar: UICollectionView {
    weak var barDelegate: NavigationBarDelegate?
    
    var titles = [String]()

    init(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: LiftNavigationController.navigationBarHeight)
        
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
        self.contentInset = UIEdgeInsetsMake(0, 100, 0, 100)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func highLightIndex(index: Int) {
        self.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension NavigationBar: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return titles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationCell.identifier, for: indexPath) as! NavigationCell
        cell.titleLabel.text = self.titles[indexPath.row]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       self.barDelegate?.selectItemAt(indexPath.row, onNavigationBar: self)
    }
}
