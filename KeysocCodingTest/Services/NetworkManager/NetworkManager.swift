//
//  NetworkManager.swift
//  KeysocCodingTest
//
//  Created by Wing on 2/3/2022.
//

import Alamofire
import Foundation
import Moya
import RxSwift

struct NetworkManager {
    internal let provider: MoyaProvider<MultiTarget>

    // https://github.com/moya/moya/issues/743#issuecomment-258643529
    private class DefaultAlamofireManager: Session {
        static func sharedManager(requestTimeOut: Double) -> DefaultAlamofireManager {
            let configuration = URLSessionConfiguration.default
            configuration.headers = .default
            configuration.timeoutIntervalForRequest = requestTimeOut
            //        configuration.timeoutIntervalForResource = 30
            configuration.requestCachePolicy = .useProtocolCachePolicy
            return DefaultAlamofireManager(configuration: configuration)
        }
    }

    public init(requestTimeOut: Double) {
        self.provider = MoyaProvider<MultiTarget>(
            session: DefaultAlamofireManager.sharedManager(requestTimeOut: requestTimeOut),
            trackInflights: false
        )
    }
}

extension NetworkManager {
    func getAlbum(term: String, entity: String) -> Observable<ItunesSearchResponse> {
        print("getAlbum")
        return provider.rx
            .request(MultiTarget(ItunesAPI.search(term: term, entity: entity)))
            .filterSuccessfulStatusAndRedirectCodes()
            .map(ItunesSearchResponse.self)
            .asObservable()
    }
}
