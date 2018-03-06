//
//  Created by Nikolay Sohryakov on 27/02/2018.
//

import Foundation
import RxSwift
import Action
import NSObject_Rx

typealias ArticleType = Article

protocol MainViewModelInputsType {
    // Mainly `PublishSubject` here
    var refresh: PublishSubject<Void> { get }
}

protocol MainViewModelOutputsType {
    // Mainly `Observable` here
    var data: Observable<[Article]>? { get }
}

protocol MainViewModelActionsType {
    // Mainly `Actions` here
}

protocol MainViewModelType {
    var inputs:  MainViewModelInputsType  { get }
    var outputs: MainViewModelOutputsType { get }
    var actions: MainViewModelActionsType { get }
}

class MainViewModel: MainViewModelType {
    var inputs:  MainViewModelInputsType  { return self }
    var outputs: MainViewModelOutputsType { return self }
    var actions: MainViewModelActionsType { return self }
    
    // MARK: Setup
    fileprivate var coordinator: SceneCoordinatorType
    fileprivate var service: ArticlesSearchServiceType
    
    // MARK: Inputs
    private(set) var refresh: PublishSubject<Void> = PublishSubject<Void>()

    
    // MARK: Outputs
    private(set) var data: Observable<[ArticleType]>?

    // MARK: ViewModel Life Cycle
    private var hits: Int = 0

    init(coordinator: SceneCoordinatorType, service: ArticlesSearchServiceType) {
        // Setup
        self.coordinator = coordinator
        self.service = service

        // Inputs
        
        // Outputs

        let articles = Observable.of(Observable<Void>.just(()), refresh).merge().flatMap { _ in
            return service.observeAllArticles()
        }.share(replay: 1)

        data = articles.map { $0.0 }.share(replay: 1)

        // ViewModel Life Cycle
        articles.subscribe(onNext: {
                    self.hits = $0.1
                    print(self.hits)
                })
                .disposed(by: self.disposeBag)
    }
}

extension MainViewModel: MainViewModelInputsType, MainViewModelOutputsType, MainViewModelActionsType, HasDisposeBag {}
