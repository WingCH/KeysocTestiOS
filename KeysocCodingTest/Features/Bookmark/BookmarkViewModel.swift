//
//  BookmarkViewModel.swift
//  KeysocCodingTest
//
//  Created by Wing on 2/3/2022.
//

import Foundation
import RxCocoa
import RxSwift

class BookmarkViewModel {
    // -- output --
    var albumCellModels = BehaviorRelay<[AlbumCellModel]>(value: [])
    // -- output --

    // -- dependency --
    let bookmarkRepository: BookmarkRepository
    // -- dependency --

    let disposeBag = DisposeBag()

    init(bookmarkRepository: BookmarkRepository) {
        self.bookmarkRepository = bookmarkRepository

        bookmarkRepository.albums
            .subscribe(onNext: { bookmarkedAlbums in
                let cellModels = bookmarkedAlbums.map { albums in
                    AlbumCellModel(album: albums, isBookmarked: true)
                }
                self.albumCellModels.accept(cellModels)
            }).disposed(by: disposeBag)
    }

    func onUnBookmark(cellModel: AlbumCellModel) {
        if cellModel.isBookmarked {
            bookmarkRepository.remove(cellModel.album)
        } else {
            print("!! Unexpected, isBookmarked should be true here")
        }
    }
}
