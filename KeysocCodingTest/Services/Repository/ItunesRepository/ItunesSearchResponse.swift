//
//  ItunesSearchResponce.swift
//  KeysocCodingTest
//
//  Created by Wing on 2/3/2022.
//

import Foundation

// MARK: - ItunesSearchResponse

struct ItunesSearchResponse: Codable {
    let resultCount: Int
    let results: [ItunesAlbum]

    enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }
}

// MARK: - Result

struct ItunesAlbum: Codable, Equatable {
    let wrapperType: String?
    let collectionType: String?
    let artistId: Int?
    let collectionId: Int?
    let amgArtistId: Int?
    let artistName: String?
    let collectionName: String?
    let collectionCensoredName: String?
    let artistViewUrl: String?
    let collectionViewUrl: String?
    let artworkUrl60: String?
    let artworkUrl100: String?
    let collectionPrice: Double?
    let collectionExplicitness: String?
    let trackCount: Int?
    let copyright: String?
    let country: String?
    let currency: String?
    let releaseDate: String?
    let primaryGenreName: String?
    let contentAdvisoryRating: String?

    enum CodingKeys: String, CodingKey {
        case wrapperType
        case collectionType
        case artistId
        case collectionId
        case amgArtistId
        case artistName
        case collectionName
        case collectionCensoredName
        case artistViewUrl
        case collectionViewUrl
        case artworkUrl60
        case artworkUrl100
        case collectionPrice
        case collectionExplicitness
        case trackCount
        case copyright
        case country
        case currency
        case releaseDate
        case primaryGenreName
        case contentAdvisoryRating
    }
}
