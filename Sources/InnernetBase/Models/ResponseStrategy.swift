import Foundation

public enum ResponseStrategy {
    case mock(status: Int, data: Data?, headers: [String: String]?, httpVersion: String? = nil)
    case networkError(NetworkError)
    // TODO: redirect to local server or whatever
//    case redirect
}
