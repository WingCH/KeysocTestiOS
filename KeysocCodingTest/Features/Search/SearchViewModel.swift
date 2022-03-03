//
//  SearchViewModel.swift
//  KeysocCodingTest
//
//  Created by Wing on 1/3/2022.
//

import Moya
import RxCocoa
import RxSwift

class SearchViewModel {
    // output

    var albums = BehaviorRelay<[ItunesAlbum]>(value: [])

    let disposeBag = DisposeBag()

    let networkManager: NetworkManager = NetworkManager(requestTimeOut: 30)

    init(
        searchText: Driver<String>
//        dependency: ()
    ) {
        searchText.drive { newSearchKey in
            print("onNext: \(newSearchKey)")
            self.callAPI(newSearchKey: newSearchKey)
        } onCompleted: {
            print("onCompleted")
        } onDisposed: {
            print("onDisposed")
        }.disposed(by: disposeBag)
    }

    func callAPI(newSearchKey: String) {
        networkManager.getAlbum(term: newSearchKey, entity: "album")
            .subscribe { respose in
                print("onSuccess: \(respose)")
                self.albums.accept(respose.results)
            } onError: { error in
                print("onError: \(error)")
            } onDisposed: {
                print("onDisposed")
            }.disposed(by: disposeBag)
    }
}
