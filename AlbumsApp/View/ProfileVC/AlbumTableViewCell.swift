//
//  AlbumTableViewCell.swift
//  AlbumsApp
//
//  Created by ITSP on 20/11/2024.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

    static let albumCellIdentifier = String(describing: AlbumTableViewCell.self)
    
    @IBOutlet weak var albumNameLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      
    }
    
    func setupCell(name: String) {
        albumNameLBL.text = name
    }
    
}
