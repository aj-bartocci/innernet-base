import Foundation

public class Intercept {
    let canIntercept: (URLRequest) -> Bool
    public let onRequest: (URLRequest, @escaping (ResponseStrategy) -> Void) -> Void
    
    init(canIntercept: @escaping (URLRequest) -> Bool, onRequest: @escaping (URLRequest, @escaping (ResponseStrategy) -> Void) -> Void) {
        self.canIntercept = canIntercept
        self.onRequest = onRequest
    }
    
}
