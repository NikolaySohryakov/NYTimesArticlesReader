//
//  Created by Nikolay Sohryakov on 13/03/2018.
//

import Foundation
import UIKit.UINib
import UIKit.UIViewController

struct ArticleScene: SceneType, InstantiatableFromNIB {
    var viewModel: ArticleViewModel

    func instantiateFromNIB() -> UIViewController {
        guard let viewController = UINib.init(nibName: "Article", bundle: nil).instantiate(withOwner: nil, options: nil).first as? ArticleViewController else {
            fatalError("Unable to instantiate a view controller")
        }

        viewController.bindViewModel(to: self.viewModel)

        return viewController
    }
}