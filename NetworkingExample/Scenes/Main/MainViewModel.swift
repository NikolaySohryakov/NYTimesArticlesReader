//
//  Created by Nikolay Sohryakov on 27/02/2018.
//

import Foundation
import RxSwift
import Action

typealias ArticleType = Article

protocol MainViewModelInputsType {
    // Mainly `PublishSubject` here
}

protocol MainViewModelOutputsType {
    // Mainly `Observable` here
    var data: Observable<[Article]> { get }
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
    
    // MARK: Outputs
    private(set) var data: Observable<[ArticleType]>

    // MARK: ViewModel Life Cycle
    init(coordinator: SceneCoordinatorType, service: ArticlesSearchServiceType) {
        // Setup
        self.coordinator = coordinator
        self.service = service
        
        // Inputs
        
        // Outputs
        data = service.observeAllArticles().asObservable()
        
        // ViewModel Life Cycle
    }
    
    // MARK: Actions
}

extension MainViewModel: MainViewModelInputsType, MainViewModelOutputsType, MainViewModelActionsType {}
