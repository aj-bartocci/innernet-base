import Foundation

public struct MockResponse {
    public let status: Int
    public let data: Data?
    public let headers: [String : String]?
    
    public init(
        status: Int,
        data: Data?,
        headers: [String : String]?
    ) {
        self.status = status
        self.data = data
        self.headers = headers
    }
}
