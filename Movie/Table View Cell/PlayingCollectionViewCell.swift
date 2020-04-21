//
//  PlayingCollectionViewCell.swift
//  Movie
//
//  Created by Jin on 2/28/20.
//  Copyright © 2020 xcode365. All rights reserved.
//

import UIKit

class PlayingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterView: UIImageView!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        
        return layoutAttributes
    }
}
