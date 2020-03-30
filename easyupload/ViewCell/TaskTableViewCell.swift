//
//  TaskTableViewCell.swift
//  easyupload
//
//  Created by Cecilia on 2020/3/28.
//  Copyright © 2020 Cecilia. All rights reserved.
//

import UIKit

enum TaskTableViewCellStatus {
    case pause
    case play
}

protocol TaskTableViewCellClick {
    func btnActionClick(id: String?, status: TaskTableViewCellStatus)
}

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var labelFilename: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    
    let playIcon = UIImage(named: "play")!
    let pauseIcon = UIImage(named: "pause")!
    
    var delegate: TaskTableViewCellClick?
    var id: String?
    var status: TaskTableViewCellStatus = .play {
        didSet {
            self.btnAction.setImage((status == .pause ? playIcon : pauseIcon), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btnAction.addTarget(self, action: #selector(self.btnActionClick), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func btnActionClick() {
        var icon: UIImage!
        
        if self.status == .play {
            self.status = .pause
            icon = playIcon
        } else {
            self.status = .play
            icon = pauseIcon
        }
        
        self.btnAction.setImage(icon, for: .normal)
        self.delegate?.btnActionClick(id: self.id, status: self.status)
    }
}
