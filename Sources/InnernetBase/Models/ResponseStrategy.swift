import Foundation

public enum ResponseStrategy {
    case mock(status: Int, data: Data?, headers: [String: String]?, httpVersion: String? = nil)
    case networkError(NetworkError)
    case redirected(data: Data?, response: URLResponse?, error: Error?)
}
