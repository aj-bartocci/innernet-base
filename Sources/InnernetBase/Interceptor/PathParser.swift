import Foundation

struct PathParser {
    
    static func hasMatch(
        forReqPaths reqPaths: [String],
        against matchPaths: [String]
    ) -> Bool {
        guard matchPaths.count <= reqPaths.count else {
            // if the wildcard path is longer it will never match
            return false
        }
        if reqPaths.isEmpty && matchPaths.isEmpty {
            // found a match
            return true
        }
        guard let matchVal = matchPaths.first else {
            // if there is no match value to check then there is no match
            return false
        }
        let firstChar = String(matchVal.first ?? Character(""))
        if matchVal == WildcardKey.allPathMatch.rawValue {
            // anything following is a match
            return true
        } else if firstChar == WildcardKey.singlePathMatch.rawValue || matchVal == reqPaths.first {
            // continue checking for a match
            return hasMatch(
                forReqPaths: Array(reqPaths.dropFirst()),
                against: Array(matchPaths.dropFirst())
            )
        } else {
            // threre is no match
            return false
        }
    }
    
    private static func strippedURL(_ url: String) -> String {
        return url.replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: "http://", with: "")
    }

    private static func urlPaths(for url: String) -> [String] {
        let querySplit = url.split(separator: "?").map({ String($0) })
        var paths = querySplit.first?.split(separator: "/").map({ String($0) }) ?? [url]
        if querySplit.count == 2 {
            let query = querySplit[1]
            let queries = query.split(separator: "&").map({ String($0) })
            for queryVal in queries {
                let queryParts = queryVal.split(separator: "=").map({ String($0) })
                paths.append(contentsOf: queryParts)
            }
        }
        return paths
    }

    static func paths(for url: String) -> [String] {
        let stripped = strippedURL(url).removingPercentEncoding ?? ""
        return urlPaths(for: stripped)
    }
    
}
