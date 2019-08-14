//
//  likedTableViewCell.swift
//  Card
//
//  Created by VERTEX20 on 2019/08/14.
//  Copyright © 2019 原田悠嗣. All rights reserved.
//

import UIKit

class likedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameImage: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var work: UILabel!
    
    @IBOutlet weak var from: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
