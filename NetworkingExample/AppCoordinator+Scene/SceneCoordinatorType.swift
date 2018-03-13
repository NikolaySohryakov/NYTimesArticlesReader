//
//  Created by Nikolay Sohryakov on 27/02/2018.
//

import Foundation
import UIKit
import RxSwift

protocol SceneCoordinatorType {
    init(window: UIWindow)
    
    var currentViewController: UIViewController? { get }
    
    @discardableResult
    func transition(to scene: Navigationable?, type: SceneTransitionType) -> Completable
}

extension SceneCoordinatorType {
    //this one is to make it possible to call transition without "to:" parameter if .pop transition is required
    func transition(to scene: Navigationable? = nil, type: SceneTransitionType) -> Completable {
        return transition(to: scene, type: type)
    }
}
