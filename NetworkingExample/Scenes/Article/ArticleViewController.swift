//
// Created by Nikolay Sohryakov on 13/03/2018.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import WebKit

class ArticleViewController: UIViewController, BindableType {
    @IBOutlet weak var webView: WKWebView!
    
    var viewModel: ArticleViewModel!
    
    func bindViewModel() {
        viewModel.outputs.url.subscribe(onNext: { url in
            guard let url = url else {
                return
            }

            self.webView.load(URLRequest(url: url))
        })
    }
}
