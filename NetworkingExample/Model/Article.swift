//
// Created by Nikolay Sohryakov on 06/03/2018.
// Copyright (c) 2018 Nikolay Sohryakov. All rights reserved.
//

import Foundation

struct Article: Decodable {
    enum CodingKeys: String, CodingKey {
        case url = "web_url"
        case snippet = "snippet"
        case headline = "headline"
    }

    enum HeadlineKeys: String, CodingKey {
        case main = "main"
    }

    let url: URL?
    let headline: String?
    let snippet: String?

    init(from decoder: Decoder) throws {
        let articleContainer = try decoder.container(keyedBy: CodingKeys.self)
        let headlineContainer = try articleContainer.nestedContainer(keyedBy: HeadlineKeys.self, forKey: .headline)

        url = try articleContainer.decodeIfPresent(URL.self, forKey: .url)
        snippet = try articleContainer.decodeIfPresent(String.self, forKey: .snippet)
        headline = try headlineContainer.decode(String.self, forKey: .main)
    }
}
