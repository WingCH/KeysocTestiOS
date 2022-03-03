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
    let itunesRepository: ItunesRepository
    let bookmarkRepository: BookmarkRepository
    // -- dependency end--

    private var searchedAlbums = BehaviorRelay<[ItunesAlbum]>(value: [])
    var searchBarTextObserver = BehaviorSubject<String>(value: "")

    let disposeBag = DisposeBag()

    init(
        dependency: (
            itunesRepository: ItunesRepository,
            bookmarkRepository: BookmarkRepository
        )
    ) {
        itunesRepository = dependency.itunesRepository
        bookmarkRepository = dependency.bookmarkRepository

        // MARK: Call itunes api when search bar input text
        searchBarTextObserver
            .filter {
                !$0.isEmpty
            }
            .debug("searchBarTextObserver")
            .subscribe { newSearchKey in
                self.getAlnumsFromItunes(newSearchKey: newSearchKey)
            } onError: { error in
                print("onError: \(error)")
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
        itunesRepository.getAlbum(term: newSearchKey, entity: "album")
            .subscribe { respose in
                self.searchedAlbums.accept(respose.results)
            } onError: { error in
                print("ItunesRepository onError: \(error)")
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
