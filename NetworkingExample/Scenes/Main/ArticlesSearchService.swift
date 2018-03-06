//
// Created by Nikolay Sohryakov on 06/03/2018.
//

import Foundation
import Moya

protocol ArticlesSearchServiceType {
    var token: String { get }
}

struct ArticlesSearchService: ArticlesSearchServiceType {
    private(set) var token: String

    fileprivate lazy var provider = {
        return MoyaProvider<NYTimesArticleSearch>(plugins: [NYTimesArticleSearchAuthPlugin(token: token)])
    }()

    init(token: String) {
        self.token = token
    }
}
