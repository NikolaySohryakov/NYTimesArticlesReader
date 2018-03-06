//
// Created by Nikolay Sohryakov on 06/03/2018.
//

import Foundation
import RxSwift
import Moya

protocol ArticlesSearchServiceType {
    func observeAllArticles() -> Single<[ArticleType]>
}

struct ArticlesSearchService: ArticlesSearchServiceType {
    private(set) var token: String

    fileprivate var provider: MoyaProvider<NYTimesArticleSearch>

    init(token: String) {
        self.token = token
        self.provider = MoyaProvider<NYTimesArticleSearch>(plugins: [NYTimesArticleSearchAuthPlugin(token: token)])
    }

    func observeAllArticles() -> Single<[ArticleType]> {
        return provider.rx
                .request(.articleSearch)
                .filterSuccessfulStatusCodes()
                .map([ArticleType].self, atKeyPath:"response.docs", using: JSONDecoder())
                .catchError { _ in Single.just([]) }
    }
}
