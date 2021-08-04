import XCTest
@testable import InnernetBase

final class RequestInterceptorTests: XCTestCase {
    
    var sut: RequestInterceptor!
    
    override func setUpWithError() throws {
        sut = RequestInterceptor()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: Exact URL Matching
    
    func test_Register_Simple_URLMatch() {
        sut.register(.get, matching: "apple.com/foo") { _, _ in }
        var req = URLRequest(url: URL(string: "https://apple.com/foo")!)
        req.httpMethod = "GET"
        let intercept = sut.intercept(for: req)
        XCTAssertNotNil(intercept)
    }
    
    // MARK: Variable URL Matching
    
    func test_Register_InnerVariable_URLMatch_ReturnsIntercept() {
        sut.register(.post, matching: "apple.com/foo/*/baz") { _, _ in }
        var req = URLRequest(url: URL(string: "https://apple.com/foo/1337/baz")!)
        req.httpMethod = "POST"
        let intercept = sut.intercept(for: req)
        XCTAssertNotNil(intercept)
    }
    
    func test_Register_TrailingVariable_URLMatch_ReturnsIntercept() {
        sut.register(.post, matching: "apple.com/foo/*") { _, _ in }
        var req = URLRequest(url: URL(string: "apple.com/foo/1337")!)
        req.httpMethod = "POST"
        let intercept = sut.intercept(for: req)
        XCTAssertNotNil(intercept)
    }
    
    func test_Register_TrailingVariable_URLMismatch_ReturnsNil() {
        sut.register(.post, matching: "apple.com/foo/*") { _, _ in }
        var req = URLRequest(url: URL(string: "apple.com/foo/1337/baz")!)
        req.httpMethod = "POST"
        let intercept = sut.intercept(for: req)
        XCTAssertNil(intercept)
    }
    
    // MARK: Wildcard URL Matching
    
    func test_Register_TrailingWildcard_ReturnsIntercept() {
        sut.register(.post, matching: "apple.com/foo/**") { _, _ in }
        var req = URLRequest(url: URL(string: "apple.com/foo/1337/baz")!)
        req.httpMethod = "POST"
        let intercept = sut.intercept(for: req)
        XCTAssertNotNil(intercept)
    }
    
    func test_Register_InnerWildcard_ReturnsIntercept() {
        sut.register(.get, matching: "apple.com/foo/**/blah") { _, _ in }
        var req = URLRequest(url: URL(string: "apple.com/foo/1337/baz")!)
        req.httpMethod = "GET"
        let intercept = sut.intercept(for: req)
        XCTAssertNotNil(intercept)
    }
    
    // MARK: Manual Register
    
    func test_register_WithInterceptReturningTrue_ReturnsIntercept() {
        sut.register(.get) { _ in
            return true
        } onRequest: { _, _ in }
        var req = URLRequest(url: URL(string: "apple.com/foo/1337/baz")!)
        req.httpMethod = "GET"
        let intercept = sut.intercept(for: req)
        XCTAssertNotNil(intercept)
    }
    
    func test_register_WithInterceptReturningFalse_ReturnsNil() {
        sut.register(.get) { _ in
            return false
        } onRequest: { _, _ in }
        var req = URLRequest(url: URL(string: "apple.com/foo/1337/baz")!)
        req.httpMethod = "GET"
        let intercept = sut.intercept(for: req)
        XCTAssertNil(intercept)
    }
    
    // MARK: Overriding Intercepts
    
    func test_register_TwiceWithSameMatch_ReturnsMostRecentRegistration() {
        let url = "apple.com/foo/1337/baz"
        sut.register(.get) { req in
            return false
        } onRequest: { _, _ in }
        sut.register(.get) { req in
            if req.url?.absoluteString == url {
                return true
            }
            return false
        } onRequest: { _, _ in }
        var req = URLRequest(url: URL(string: url)!)
        req.httpMethod = "GET"
        let intercept = sut.intercept(for: req)
        XCTAssertNotNil(intercept)
    }
}
