import UIKit
import Lift

class TableController: UIViewController {
    weak var bottomControllerDelegate: BottomControllerDelegate?
    var onTopOfScrollView = false
    var lastContentOffsetY = CGFloat(0.0)

    var cellIdentifier: String {
        return String(describing: UITableViewCell.self)
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)

        self.addSubViewsAndConstraints()
    }

    func addSubViewsAndConstraints() {
        self.view.addSubview(self.tableView)

        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
}

extension TableController: BottomControllable {
    func enableScrollView() {
        self.tableView.isUserInteractionEnabled = true
    }
}

extension TableController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! UITableViewCell
        cell.textLabel?.text = "Hi there"

        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollingUp = self.lastContentOffsetY > scrollView.contentOffset.y

        let scrollingUpFromTop = self.onTopOfScrollView && scrollingUp

        if scrollingUpFromTop {
            scrollView.isUserInteractionEnabled = false
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }

        self.lastContentOffsetY = scrollView.contentOffset.y
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.onTopOfScrollView = scrollView.contentOffset.y <= 0
    }
}