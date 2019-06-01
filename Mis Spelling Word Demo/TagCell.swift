//
//  TagCell.swift
//  Tag Flow Layout
//
//  Created by Pawan kumar on 14/05/19.
//  Copyright © 2019 Pawan Kumar. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {

    @IBOutlet weak var tagName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        self.tagName.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
    }

}
