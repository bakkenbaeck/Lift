import UIKit

class NavigationBar: UICollectionView {
    var titles = [String]()

    init(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: LiftNavigationController.navigationBarHeight)
        
        super.init(frame: CGRect.zero, collectionViewLayout: layout)

        self.delegate = self
        self.dataSource = self
        self.register(NavigationCell.self, forCellWithReuseIdentifier: NavigationCell.identifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

}
