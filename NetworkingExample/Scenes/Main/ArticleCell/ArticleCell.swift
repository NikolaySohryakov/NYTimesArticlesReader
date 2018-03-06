//
//  ArticleCell.swift
//  NetworkingExample
//
//  Created by Nikolay Sohryakov on 06/03/2018.
//  Copyright © 2018 Nikolay Sohryakov. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    @IBOutlet weak var headLineLabel: UILabel!
    @IBOutlet weak var snippetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
