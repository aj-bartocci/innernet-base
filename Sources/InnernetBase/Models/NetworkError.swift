import Foundation

public enum InnernetsError: Error {
    case blockedPassthrough
    case interceptTimeout
}

extension InnernetsError: LocalizedError {
    public var failureReason: String? {
        switch self {
        case .blockedPassthrough:
            return "Request was blocked. No intercept was found and passthroughs are disabled"
        case .interceptTimeout:
            return "Request forced to timeout. Intercept took too long to complete."
        }
    }
        
    public var errorDescription: String? {
        switch self {
        case .blockedPassthrough:
            return "Request was blocked. No intercept was found and passthroughs are disabled"
        case .interceptTimeout:
            return "Request forced to timeout. Intercept took too long to complete."
        }
    }
}

extension InnernetsError: CustomNSError {

    public static var errorDomain: String {
        return "InnernetsError"
    }

    public var errorCode: Int {
        switch self {
        case .blockedPassthrough:
            return 1337
        case .interceptTimeout:
            return 1338
        }
    }

    public var errorUserInfo: [String : Any] {
        switch self {
        case .blockedPassthrough:
            return ["reason": "Request was blocked. No intercept was found and passthroughs are disabled"]
        case .interceptTimeout:
            return ["reason": "Request forced to timeout. Intercept took too long to complete."]
        }
    }
}


public enum NetworkError {
    case timeout
    case unreachable
    case framework(InnernetsError)
    case custom(Error)
}

