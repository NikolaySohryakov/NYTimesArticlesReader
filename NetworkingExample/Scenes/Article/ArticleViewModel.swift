//
//  Created by Nikolay Sohryakov on 13/03/2018.
//

import Foundation
import RxSwift
import Action
import NSObject_Rx

protocol ArticleViewModelInputsType {
    // Mainly `PublishSubject` here
}

protocol ArticleViewModelOutputsType {
    // Mainly `Observable` here
    var url: Observable<URL?> { get }
}

protocol ArticleViewModelActionsType {
    // Mainly `Actions` here
    var backAction: CocoaAction { get }
}

protocol ArticleViewModelType {
    var inputs:  ArticleViewModelInputsType  { get }
    var outputs: ArticleViewModelOutputsType { get }
    var actions: ArticleViewModelActionsType { get }
}

class ArticleViewModel: ArticleViewModelType {
    var inputs:  ArticleViewModelInputsType  { return self }
    var outputs: ArticleViewModelOutputsType { return self }
    var actions: ArticleViewModelActionsType { return self }

    // MARK: Setup
    fileprivate var coordinator: SceneCoordinatorType
    fileprivate var article: ArticleType

    // MARK: Inputs

    // MARK: Outputs
    var url: Observable<URL?>

    // MARK: ViewModel Life Cycle


    init(coordinator: SceneCoordinatorType, article: ArticleType) {
        // Setup
        self.coordinator = coordinator
        self.article = article

        // Inputs

        // Outputs
        url = Observable.just(article.url).share(replay: 1)

        // ViewModel Life Cycle
    }

    // MARK: Actions
    lazy var backAction: CocoaAction = {
        return CocoaAction {
            return self.coordinator.transition(type: .pop(animated: true, level: .parent)).asObservable().map { _ in () }
        }
    }()
}

extension ArticleViewModel: ArticleViewModelInputsType, ArticleViewModelOutputsType, ArticleViewModelActionsType, HasDisposeBag {}
