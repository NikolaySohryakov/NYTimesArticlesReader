//
//  Created by Nikolay Sohryakov on 27/02/2018.
//

import UIKit
import RxSwift

class MainViewController: UIViewController, BindableType {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MainViewModel!

    override func viewDidLoad() {
        tableView.register(ArticleCell.nib, forCellReuseIdentifier: ArticleCell.reuseIdentifier)
    }

    func bindViewModel() {
        viewModel.data
                .bind(to: tableView.rx.items(cellIdentifier: ArticleCell.reuseIdentifier, cellType: ArticleCell.self)) { (row: Int, element: ArticleType, cell: ArticleCell) in
                    cell.headLineLabel.text = element.headline
                    cell.snippetLabel.text = element.snippet
                }
                .disposed(by: rx.disposeBag)
    }
}
