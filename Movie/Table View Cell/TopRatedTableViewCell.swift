//
//  TopRatedTableViewCell.swift
//  Movie
//
//  Created by Jin on 2/24/20.
//  Copyright © 2020 xcode365. All rights reserved.
//

import UIKit

class TopRatedTableViewCell: UITableViewCell {

    @IBOutlet weak var movieCoverImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    @IBOutlet weak var lblNumbers: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
