//
//  BookmarkRepository.swift
//  KeysocCodingTest
//
//  Created by Wing on 2/3/2022.
//

import Foundation
import RxCocoa
import RxSwift

protocol BookmarkRepository {
    var albums: BehaviorRelay<[ItunesAlbum]> { get }
    func add(_ album: ItunesAlbum)
    func remove(_ album: ItunesAlbum)
}

class LocalBookmarkRepository: BookmarkRepository {
    enum UserDefaultsKeys: String {
        case bookmark
    }

    let albums = BehaviorRelay<[ItunesAlbum]>(value: [])

    let disposeBag = DisposeBag()

    init() {
        if let localAlbums = loadFromUserDefaults() {
            albums.accept(localAlbums)
        }

        albums.asObservable().subscribe { list in
            self.writeToUserDefaults(list)
        }.disposed(by: disposeBag)
    }

    func add(_ album: ItunesAlbum) {
        var existingData: [ItunesAlbum] = albums.value
        existingData.append(album)
        albums.accept(existingData)
    }

    func remove(_ album: ItunesAlbum) {
        var existingData: [ItunesAlbum] = albums.value
        if let index = existingData.firstIndex(of: album) {
            existingData.remove(at: index)
        }
        albums.accept(existingData)
    }

    private func loadFromUserDefaults() -> [ItunesAlbum]? {
        if let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.bookmark.rawValue) {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                let albums = try decoder.decode([ItunesAlbum].self, from: data)
                return albums
            } catch {
                print("Unable to Decode Notes (\(error))")
                return nil
            }
        } else {
            return nil
        }
    }

    private func writeToUserDefaults(_ albums: [ItunesAlbum]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(albums)
            UserDefaults.standard.set(data, forKey: UserDefaultsKeys.bookmark.rawValue)
        } catch {
            print("Unable to Encode Array of Notes (\(error))")
        }
    }
}
