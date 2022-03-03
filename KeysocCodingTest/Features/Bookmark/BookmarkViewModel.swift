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
    let disposeBag = DisposeBag()

    init(bookmarkRepository: BookmarkRepository) {
        
        bookmarkRepository.albums.subscribe { itunesAlbumList in
            print("onNext: \(itunesAlbumList)")
        } onError: { error in
            print("onError: \(error)")
        } onCompleted: {
            print("onCompleted")
        } onDisposed: {
            print("onDisposed")
        }.disposed(by: disposeBag)
//
//        bookmarkRepository.add(ItunesAlbum(wrapperType: "collection", collectionType: "Album", artistId: 909253, collectionId: 1469577723, amgArtistId: 468749, artistName: "Jack Johnson", collectionName: "Jack Johnson and Friends: Sing-A-Longs and Lullabies for the Film Curious George", collectionCensoredName: "Jack Johnson and Friends: Sing-A-Longs and Lullabies for the Film Curious George", artistViewUrl: "https://music.apple.com/us/artist/jack-johnson/909253?uo=4", collectionViewUrl: "https://music.apple.com/us/album/jack-johnson-and-friends-sing-a-longs-and/1469577723?uo=4", artworkUrl60:"https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/ae/4c/d4/ae4cd42a-80a9-d950-16f5-36f01a9e1881/source/60x60bb.jpg", artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/ae/4c/d4/ae4cd42a-80a9-d950-16f5-36f01a9e1881/source/100x100bb.jpg", collectionPrice:9.99, collectionExplicitness: "notExplicit", trackCount: 15, copyright: "℗ 2014 Brushfire Records", country: "USA", currency: "USD", releaseDate: "2006-02-07T08:00:00Z", primaryGenreName: "Rock", contentAdvisoryRating: nil))
    }
}
