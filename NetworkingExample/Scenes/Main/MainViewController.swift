//
//  Created by Nikolay Sohryakov on 27/02/2018.
//

import UIKit
import RxSwift

class MainViewController: UIViewController, BindableType {
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl: UIRefreshControl = { UIRefreshControl() }()
    
    var viewModel: MainViewModel!

    override func viewDidLoad() {
        tableView.refreshControl = refreshControl

        tableView.register(ArticleCell.nib, forCellReuseIdentifier: ArticleCell.reuseIdentifier)
    }

    func bindViewModel() {
        refreshControl.rx
                .controlEvent(.valueChanged)
                .map { _ in self.refreshControl.isRefreshing }
                .filter { $0 == true }
                .subscribe({_ in
                    self.viewModel.refresh.onNext(())
                })
                .disposed(by: rx.disposeBag)

        viewModel.data?
                .map {_ in false}
                .bind(to:refreshControl.rx.isRefreshing)
                .disposed(by: rx.disposeBag)

        viewModel.data?
                .bind(to: tableView.rx.items(cellIdentifier: ArticleCell.reuseIdentifier, cellType: ArticleCell.self)) { (row: Int, element: ArticleType, cell: ArticleCell) in
                    cell.headLineLabel.text = element.headline
                    cell.snippetLabel.text = element.snippet
                }
                .disposed(by: rx.disposeBag)
    }
}
