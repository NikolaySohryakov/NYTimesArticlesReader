//
// Created by Nikolay Sohryakov on 06/03/2018.
//

import Foundation
import Moya

final class NYTimesArticleSearchAuthPlugin: PluginType {
    private var token: String

    init(token: String) {
        self.token = token
    }

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let unwrappedURL = request.url,
              var urlComponents = URLComponents(url: unwrappedURL, resolvingAgainstBaseURL: true) else {
            return request
        }

        var request = request
        urlComponents.queryItems?.append(URLQueryItem(name: "api-key", value: token))

        request.url = urlComponents.url

        return request
    }
}
