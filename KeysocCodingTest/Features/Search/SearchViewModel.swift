//
//  SearchViewModel.swift
//  KeysocCodingTest
//
//  Created by Wing on 1/3/2022.
//

import RxCocoa
import RxSwift

class SearchViewModel {
    // output

    let albums: Observable<[String]>

    let disposeBag = DisposeBag()
    init(
        searchText: Driver<String>
//        dependency: ()
    ) {
        albums = searchText.asObservable()
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[String]> in
                if query.isEmpty {
                    return .just([])
                }
//                return searchGitHub(query)
//                    .catchAndReturn([])

                return Observable.just(query.map {String($0)})
            }
    }
}
