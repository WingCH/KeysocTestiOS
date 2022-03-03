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
    // -- output --
    var albumCellModels = BehaviorRelay<[AlbumCellModel]>(value: [])
    // -- output --

    // -- dependency --
    let itunesRepository: ItunesRepository
    let bookmarkRepository: BookmarkRepository
    // -- dependency --

    private var searchedAlbums = BehaviorRelay<[ItunesAlbum]>(value: [])
    var searchBarTextObserver = BehaviorRelay<String>(value: "")

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
            .subscribe(onNext: { newSearchKey in
                self.getAlnumsFromItunes(newSearchKey: newSearchKey)
            }).disposed(by: disposeBag)

        Observable.combineLatest(searchedAlbums, bookmarkRepository.albums) { albums, bookmarkedAlbums in
            albums.map { album in
                AlbumCellModel(album: album, isBookmarked: bookmarkedAlbums.contains(album))
            }
        }.bind(to: albumCellModels).disposed(by: disposeBag)
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
    
    func onClickExampleButton(searchKey: String){
        searchBarTextObserver.accept(searchKey)
    }
}
