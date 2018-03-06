//
//  Created by Nikolay Sohryakov on 27/02/2018.
//

import XCTest
import Moya
@testable import NetworkingExample

class NetworkingExampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSearchArticle() {
        let provider = MoyaProvider<NYTimesArticle>()
    }
}
