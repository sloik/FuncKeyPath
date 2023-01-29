import XCTest
import FuncKeyPath

import Foundation

final class FuncKeyPathTests: XCTestCase {

    func testOperatorIsVisibleAndCompiles() throws {
        let _ : [String?]  = [].map( ^\URL.scheme )
    }
}
