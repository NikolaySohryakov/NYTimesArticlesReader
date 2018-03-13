//
//  Created by Nikolay Sohryakov on 28/02/2018.
//

import Foundation
import UIKit.UINib
import UIKit.UIViewController

struct MainScene: SceneType, InstantiatableFromNIB {
    var viewModel: MainViewModel
    
    func instantiateFromNIB() -> UIViewController {
        guard let viewController = UINib.init(nibName: "Main", bundle: nil).instantiate(withOwner: nil, options: nil).first as? MainViewController else {
            fatalError("Unable to instantiate a view controller")
        }

        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.title = "Articles"
        viewController.bindViewModel(to: self.viewModel)
        
        return navigationController
    }
}
