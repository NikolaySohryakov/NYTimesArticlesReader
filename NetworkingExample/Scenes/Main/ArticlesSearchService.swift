//
// Created by Nikolay Sohryakov on 06/03/2018.
//

import Foundation
import RxSwift
import Moya

protocol ArticlesSearchServiceType {
    func observeArticles(page: Int, searchText: String?) -> Single<([ArticleType], Int)>
}

struct ArticlesSearchService: ArticlesSearchServiceType {
    private(set) var token: String

    fileprivate var provider: MoyaProvider<NYTimesArticleSearch>

    init(token: String) {
        self.token = token
        self.provider = MoyaProvider<NYTimesArticleSearch>(plugins: [NYTimesArticleSearchAuthPlugin(token: token)])
    }

    func observeArticles(page: Int, searchText: String?) -> Single<([ArticleType], Int)> {
        return provider.rx
                .request(.articleSearch(page, searchText))
                .filterSuccessfulStatusCodes()
                .flatMap {response in
                    let decoder = JSONDecoder()

                    let articles = try? response.map([ArticleType].self, atKeyPath: "response.docs", using: decoder, failsOnEmptyData: false)
                    let hits = try? response.map(Int.self, atKeyPath: "response.meta.hits", using: decoder, failsOnEmptyData: false)

                    return Single.just((articles ?? [], hits ?? 0))
                }
                .catchError { _ in return Single.just(([], 0)) }
    }
}
