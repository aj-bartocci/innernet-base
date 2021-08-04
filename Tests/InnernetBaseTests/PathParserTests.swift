import XCTest
@testable import InnernetBase

final class PathParserTests: XCTestCase {
    
    // MARK: URL Paths
    func test_paths_ForExactMatch() {
        let paths = PathParser.paths(for: "https://apple.com/foo/bar/baz")
        let expected = ["apple.com","foo","bar","baz"]
        XCTAssertEqual(paths, expected)
    }
    
    func test_paths_RemovesPercentEncoding() {
        let paths = PathParser.paths(for: "https://apple.com/foo?bar=40%25&baz=$100")
        let expected = ["apple.com","foo","bar","40%","baz","$100"]
        XCTAssertEqual(paths, expected)
    }
    
    func test_paths_ForVariables() {
        let paths = PathParser.paths(for: "https://apple.com/:foo/bar/:baz")
        let expected = ["apple.com",":foo","bar",":baz"]
        XCTAssertEqual(paths, expected)
    }
    
    func test_paths_ForWildcard() {
        let paths = PathParser.paths(for: "https://apple.com/foo/*")
        let expected = ["apple.com","foo","*"]
        XCTAssertEqual(paths, expected)
    }
    
    func test_paths_ForExactQuery() {
        let paths = PathParser.paths(for: "https://apple.com/?foo=bar&baz=biz")
        let expected = ["apple.com","foo","bar","baz","biz"]
        XCTAssertEqual(paths, expected)
    }
    
    func test_paths_ForVariableQuery() {
        let paths = PathParser.paths(for: "https://apple.com/?foo=:bar&baz=:biz")
        let expected = ["apple.com","foo",":bar","baz",":biz"]
        XCTAssertEqual(paths, expected)
    }
    
    // MARK: Matching
    
    func test_hasMatch_ForExactPathsMatch() {
        let reqPaths = ["apple.com","foo","bar","baz","biz"]
        let matchPaths = ["apple.com","foo","bar","baz","biz"]
        let hasMatch = PathParser.hasMatch(
            forReqPaths: reqPaths,
            against: matchPaths
        )
        XCTAssertTrue(hasMatch)
    }
    
    func test_hasMatch_ForVariablePathsMatch() {
        let reqPaths = ["apple.com","foo","bar","baz","biz"]
        let matchPaths = ["apple.com","foo","*","baz","*"]
        let hasMatch = PathParser.hasMatch(
            forReqPaths: reqPaths,
            against: matchPaths
        )
        XCTAssertTrue(hasMatch)
    }
    
    func test_hasMatch_ForWildcardMatch() {
        let reqPaths = ["apple.com","foo","bar","baz","biz"]
        let matchPaths = ["apple.com","foo","**"]
        let hasMatch = PathParser.hasMatch(
            forReqPaths: reqPaths,
            against: matchPaths
        )
        XCTAssertTrue(hasMatch)
    }
}
