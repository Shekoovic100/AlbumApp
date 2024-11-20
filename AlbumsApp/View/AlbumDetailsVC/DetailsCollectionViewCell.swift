//
//  DetailsCollectionViewCell.swift
//  AlbumsApp
//
//  Created by ITSP on 20/11/2024.
//

import UIKit
import Kingfisher

class DetailsCollectionViewCell: UICollectionViewCell {

    static let collectionViewCellIdentifier = String(describing: DetailsCollectionViewCell.self)
    
    @IBOutlet weak var albumImageDetails: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupImage(imageUrl: String) {
        guard let url = URL(string: imageUrl) else {
            return
        }
        albumImageDetails.kf.setImage(with: url,placeholder: UIImage(named: "placeholder"))
    }

}
