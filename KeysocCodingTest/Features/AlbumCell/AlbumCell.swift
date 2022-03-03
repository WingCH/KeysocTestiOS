//
//  AlbumCell.swift
//  KeysocCodingTest
//
//  Created by Wing on 1/3/2022.
//

import Kingfisher
import RxCocoa
import RxSwift
import UIKit

class AlbumCell: UITableViewCell {
    @IBOutlet var artworkImageView: UIImageView!
    @IBOutlet var collectionNameLabel: UILabel!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var collectionPriceButton: UIButton!

    // https://www.hangge.com/blog/cache/detail_2047.html
    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        artworkImageView.backgroundColor = .gray
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(model: AlbumCellModel) {
        setImage(imageUrl: model.album.artworkUrl100)
        collectionNameLabel.text = model.album.collectionName
        artistNameLabel.text = model.album.artistName

        if model.isBookmarked {
            backgroundColor = .red
        } else {
            backgroundColor = .gray
        }
    }

    private func setImage(imageUrl: String?) {
        if let artworkUrl = imageUrl, let url = URL(string: artworkUrl) {
            artworkImageView.kf.indicatorType = .activity
            artworkImageView.kf.setImage(with: url)
        }
    }
}
