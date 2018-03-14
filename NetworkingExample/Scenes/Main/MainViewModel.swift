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
    var loadNextPage: PublishSubject<Void> { get }
    var updateForSearchText: PublishSubject<String?> { get }
}

protocol MainViewModelOutputsType {
    // Mainly `Observable` here
    var data: Observable<[Article]> { get }
}

protocol MainViewModelActionsType {
    // Mainly `Actions` here
    var showArticle: Action<Article, Never> { get }
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
    private(set) var refresh: PublishSubject<Void>
    private(set) var loadNextPage: PublishSubject<Void>
    private(set) var updateForSearchText: PublishSubject<String?>

    // MARK: Outputs
    private(set) var data: Observable<[ArticleType]>

    // MARK: ViewModel Life Cycle
    private var hits: Int = 0
    private var nextPage: Int = 0
    private var loadingInProgress: Bool = false
    private var shouldLoadNextPage: Bool = true //TODO: support this
    private var searchText: BehaviorSubject<String?>

    init(coordinator: SceneCoordinatorType, service: ArticlesSearchServiceType) {
        // Setup
        self.coordinator = coordinator
        self.service = service
        self.data = Observable.just([])
        self.searchText = BehaviorSubject<String?>(value: "")

        // Inputs
        refresh = PublishSubject<Void>()
        loadNextPage = PublishSubject<Void>()
        updateForSearchText = PublishSubject<String?>()

        // ViewModel Life Cycle
        updateForSearchText.subscribe(searchText).disposed(by: disposeBag)

        let loadFirstPageTrigger =
                refresh.flatMapLatest { _ -> Observable<Void> in
                    self.nextPage = 0
                    return Observable.just(())
                }
        let loadNextPageTrigger = loadNextPage
                .filter { !self.loadingInProgress && self.shouldLoadNextPage }
                .flatMapLatest { _ -> Observable<Void> in
                    self.nextPage += 1
                    return Observable.just(())
                }
        let searchTextChangedTrigger = searchText
                .distinctUntilChanged { lhs, rhs in
                    return lhs == rhs
                }
                .filter { ($0?.count ?? 0) > 2 } //perform search only if the search phrase is more than 2 symbols
                .debounce(0.5, scheduler: MainScheduler.instance)
                .map { _ in () }
                .skip(1)

        let articles =
                Observable
                .of(loadFirstPageTrigger, loadNextPageTrigger, searchTextChangedTrigger)
                .merge()
                .flatMap { () -> Single<([ArticleType], Int)> in
                    let searchText = try self.searchText.value()

                    self.loadingInProgress = true
                    return service.observeArticles(page: self.nextPage, searchText:searchText)
                }
                .share()


        articles.subscribe(onNext: {[unowned self] tuple in
                    self.loadingInProgress = false
                    self.hits = tuple.1
                })
                .disposed(by: self.disposeBag)

        // Outputs
        data = articles
                .scan([]) { self.nextPage > 0 ? $0 + $1.0 : $1.0 }
                .startWith([])
                .share(replay: 1)

        // Actions
    }

    lazy var showArticle: Action<Article, Never> = {
        return Action { article in
            let viewModel = ArticleViewModel(coordinator: self.coordinator, article: article)
            let scene = ArticleScene(viewModel: viewModel)

            return self.coordinator.transition(to: scene, type: .push(animated: true)).asObservable()
        }
    }()
}

extension MainViewModel: MainViewModelInputsType, MainViewModelOutputsType, MainViewModelActionsType, HasDisposeBag {}
