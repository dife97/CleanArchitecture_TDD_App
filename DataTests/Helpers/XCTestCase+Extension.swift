import XCTest

extension XCTestCase {
    
    func checkMemoryLeak(
        for instance: AnyObject,
        _ file: StaticString = #filePath,
        _ line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}
