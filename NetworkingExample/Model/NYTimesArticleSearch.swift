//
//  Created by Nikolay Sohryakov on 04/03/2018.
//

import Foundation
import Moya

enum NYTimesArticleSearch {
    case articleSearch(Int)
}

extension NYTimesArticleSearch: TargetType {
    //TODO: force unwrap here is NOT ok
    var baseURL: URL {
        return URL(string: "https://api.nytimes.com/svc/search/v2")!
    }

    var path: String {
        switch self {
        case .articleSearch:
            return "/articlesearch.json"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        switch self {
        case .articleSearch:
            return SampleDataLoader.file(fileName: "ArticleSearch.json").load()! // TODO: this forceunwrap is NOT ok
        }
    }

    var task: Task {
        switch self {
        case .articleSearch(let page):
            let params = ["page":page]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
