//
//  ItunesRepository.swift
//  KeysocCodingTest
//
//  Created by Wing on 3/3/2022.
//

import Foundation
import Moya
import RxSwift

protocol ItunesRepository {
    func getAlbum(term: String, entity: String) -> Observable<ItunesSearchResponse>
}

class RemoteItunesRepository: ItunesRepository {
    let provider: MoyaProvider<ItunesAPI>

    init(provider: MoyaProvider<ItunesAPI>) {
        self.provider = provider
    }

    func getAlbum(term: String, entity: String) -> Observable<ItunesSearchResponse> {
        return provider.rx
            .request(.search(term: term, entity: entity))
            .filterSuccessfulStatusAndRedirectCodes()
            .map(ItunesSearchResponse.self)
            .asObservable()
    }
}
