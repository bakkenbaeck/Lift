import UIKit
import Lift

class TableController: UIViewController, BottomControllable {
    
    weak var pullToNavigateDelegate: PullToNavigateUpDelegate?

    weak var bottomControllerDelegate: BottomControllerDelegate?

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

extension TableController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        cell.textLabel?.text = "Hi there"

        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + scrollView.contentInset.top

        if offset <= 0.0 {
            let startLoadingThreshold: CGFloat = 100.0
            let fractionDragged = -offset / startLoadingThreshold

            self.pullToNavigateDelegate?.didUpdatePullToNavigateUpThreshold(percentage: max(fractionDragged, CGFloat(0)))

            if fractionDragged >= 1.0 {
                self.bottomControllerDelegate?.requestToSwitchToTop(from: self)
            }
        }
    }
}
