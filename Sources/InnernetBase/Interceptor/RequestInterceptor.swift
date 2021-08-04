import Foundation

public class RequestInterceptor {
    
    public enum HTTPMethod {
        case get
        case head
        case post
        case put
        case delete
        case connect
        case options
        case trace
        case patch
        case custom(String)
        
        var rawValue: String {
            switch self {
            case .get:
                return "GET"
            case .head:
                return "HEAD"
            case .post:
                return "POST"
            case .put:
                return "PUT"
            case .delete:
                return "DELETE"
            case .connect:
                return "CONNECT"
            case .options:
                return "OPTIONS"
            case .trace:
                return "TRACE"
            case .patch:
                return "PATCH"
            case let .custom(value):
                return value
            }
        }
    }

    private var registeredRoutes: [String: [Intercept]] = [:]
    
    public init() { }
}

public extension RequestInterceptor {
            
    func intercept(
        for request: URLRequest
    ) -> Intercept? {
        let method = request.httpMethod ?? "GET"
        let possibleMatches = registeredRoutes[method] ?? []
        for possibleMatch in possibleMatches {
            if possibleMatch.canIntercept(request) {
                return possibleMatch
            }
        }
        return nil
    }
    
    /**
     Registration funcution used for simple request matching. The request will match against the URL path and HTTPMethod. If more complex matching is needed use the **register(_ method: HTTPMethod, canIntercept: @escaping (URLRequest) -> Bool, onRequest: @escaping (URLRequest, @escaping (ResponseStrategy) -> Void) -> Void)** instead
     */
    func register(
        _ method: HTTPMethod,
        matching url: String,
        onRequest: @escaping (URLRequest, @escaping (ResponseStrategy) -> Void) -> Void
    ) {
        let intercept = Intercept(
            canIntercept: { req in
                guard let reqURL = req.url?.absoluteString else {
                    return false
                }
                let reqPaths = PathParser.paths(for: reqURL)
                let interceptPaths = PathParser.paths(for: url)
                return PathParser.hasMatch(
                    forReqPaths: reqPaths,
                    against: interceptPaths
                )
            },
            onRequest: onRequest
        )
        addIntercept(intercept, forMethod: method)
    }
    
    /**
     The function that all registrations go through. This can be used to do more complex intercept matching like checking against request headers, body, etc.
     */
    func register(
        _ method: HTTPMethod,
        canIntercept: @escaping (URLRequest) -> Bool,
        onRequest: @escaping (URLRequest, @escaping (ResponseStrategy) -> Void) -> Void
    ) {
        let intercept = Intercept(
            canIntercept: canIntercept,
            onRequest: onRequest
        )
        addIntercept(intercept, forMethod: method)
    }
 
    func unregisterAll() {
        registeredRoutes = [:]
    }
}

private extension RequestInterceptor {
    
    func addIntercept(
        _ intercept: Intercept,
        forMethod method: HTTPMethod
    ) {
        if registeredRoutes[method.rawValue] != nil {
            registeredRoutes[method.rawValue]?.insert(intercept, at: 0)
        } else {
            registeredRoutes[method.rawValue] = [intercept]
        }
    }
}
