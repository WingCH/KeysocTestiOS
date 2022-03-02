//
//  AlbumCell.swift
//  KeysocCodingTest
//
//  Created by Wing on 1/3/2022.
//

import Kingfisher
import UIKit

class AlbumCell: UITableViewCell {
    @IBOutlet var artworkImageView: UIImageView!
    @IBOutlet var collectionNameLabel: UILabel!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var collectionPriceButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.backgroundColor = .red
        artworkImageView.backgroundColor = .gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setImage(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            artworkImageView.kf.indicatorType = .activity
            artworkImageView.kf.setImage(with: url)
        }
    }
}
