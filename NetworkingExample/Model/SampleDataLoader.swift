//
//  Created by Nikolay Sohryakov on 06/03/2018.
//

import Foundation

enum SampleDataLoader {
    case file(fileName: String)
}

extension SampleDataLoader {
    func load() -> Data? {
        switch self {
        case .file(let fileName):
            guard let path = Bundle.main.path(forResource: fileName,
                                              ofType: "txt",
                                              inDirectory: nil,
                                              forLocalization: nil) else {
                return "".data(using: .utf8)
            }
        
            return try? Data(contentsOf: URL(fileURLWithPath: path))
        }
    }
}
