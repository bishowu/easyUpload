//
//  SelectCollectionViewCell.swift
//  easyupload
//
//  Created by Cecilia on 2020/3/28.
//  Copyright © 2020 Cecilia. All rights reserved.
//

import UIKit

class SelectCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var videoIcon: UIImageView!
    
    enum CellType {
        case video
        case image
    }
    
    var type: CellType = .image {
        didSet {
            self.videoIcon.isHidden = (self.type != .video)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
