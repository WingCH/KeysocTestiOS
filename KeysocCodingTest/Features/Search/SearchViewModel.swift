//
//  SearchViewModel.swift
//  KeysocCodingTest
//
//  Created by Wing on 1/3/2022.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

class SearchViewModel {
    // -- output start--
    var albumCellModels = BehaviorRelay<[AlbumCellModel]>(value: [])
    // -- output end--

    // -- dependency start--
    let networkManager: NetworkManager
    let bookmarkRepository: BookmarkRepository
    // -- dependency end--

    private var searchedAlbums = BehaviorRelay<[ItunesAlbum]>(value: [])

    let disposeBag = DisposeBag()

    init(
        searchText: Driver<String>,
        dependency: (
            networkManager: NetworkManager,
            bookmarkRepository: BookmarkRepository
        )
    ) {
        self.networkManager = dependency.networkManager
        self.bookmarkRepository = dependency.bookmarkRepository

        // MARK: Call itunes api when search bar input text

        searchText.drive { newSearchKey in
            print("onNext: \(newSearchKey)")
            self.getAlnumsFromItunes(newSearchKey: newSearchKey)
        } onCompleted: {
            print("onCompleted")
        } onDisposed: {
            print("onDisposed")
        }.disposed(by: disposeBag)

        Observable.combineLatest(searchedAlbums, bookmarkRepository.albums) { albums, bookmarkedAlbums in
            albums.map { album in
                AlbumCellModel(album: album, isBookmarked: bookmarkedAlbums.contains(album))
            }
        }.bind(to: albumCellModels).disposed(by: disposeBag)

        /*
         debug use
         albumCellModels.subscribe { cellsData in
             print("cells onNext: \(cellsData)")
         } onError: { error in
             print("cells onError: \(error)")
         } onCompleted: {
             print("cells onCompleted")
         } onDisposed: {
             print("cells onDisposed")
         }.disposed(by: disposeBag)
         */
    }

    private func getAlnumsFromItunes(newSearchKey: String) {
        networkManager.getAlbum(term: newSearchKey, entity: "album")
            .subscribe { respose in
                print("onSuccess: \(respose)")
                self.searchedAlbums.accept(respose.results)
            } onError: { error in
                print("onError: \(error)")
            } onDisposed: {
                print("onDisposed")
            }.disposed(by: disposeBag)
    }

    func onBookedMarkAlbum(cellModel: AlbumCellModel) {
        if cellModel.isBookmarked {
            bookmarkRepository.remove(cellModel.album)
        } else {
            bookmarkRepository.add(cellModel.album)
        }
    }
}
