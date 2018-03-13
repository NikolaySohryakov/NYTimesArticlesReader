//
//  Created by Nikolay Sohryakov on 27/02/2018.
//

import UIKit
import RxSwift
import RxCocoa

extension UIScrollView {
    func  isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}

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

        viewModel.data
                .map {_ in false}
                .bind(to:refreshControl.rx.isRefreshing)
                .disposed(by: rx.disposeBag)

        viewModel.data
                .bind(to: tableView.rx.items(cellIdentifier: ArticleCell.reuseIdentifier, cellType: ArticleCell.self)) { (row: Int, element: ArticleType, cell: ArticleCell) in
                    cell.headLineLabel.text = element.headline
                    cell.snippetLabel.text = element.snippet
                }
                .disposed(by: rx.disposeBag)

        tableView.rx
                .contentOffset
                .flatMap { _ -> Signal<Void> in
                    return self.tableView.isNearBottomEdge(edgeOffset: 20.0)
                            ? Signal.just(())
                            : Signal.empty()
                }
                .subscribe(onNext: {
                    self.viewModel.loadNextPage.onNext(())
                })
                .disposed(by: rx.disposeBag)

        tableView.rx
                .modelSelected(Article.self)
                .subscribe(onNext: { article in
                    self.viewModel.showArticle.execute(article)
                })
                .disposed(by: rx.disposeBag)

        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
