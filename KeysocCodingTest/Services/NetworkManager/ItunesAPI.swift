//
//  ItunesAPI.swift
//  KeysocCodingTest
//
//  Created by Wing on 2/3/2022.
//

import Foundation
import Moya

enum ItunesAPI {
    case search(term: String, entity: String)
}

extension ItunesAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://itunes.apple.com")!
    }

    var path: String {
        switch self {
        case .search:
            return "/search"
        }
    }

    var method: Moya.Method {
        switch self {
        case .search:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .search(let term, let entity):
            return .requestParameters(parameters: ["term": term, "entity": entity], encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return nil
    }

    var validationType: ValidationType {
        switch self {
        case .search:
            return .successAndRedirectCodes
        }
    }
}
