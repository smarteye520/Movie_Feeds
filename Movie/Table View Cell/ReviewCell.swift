//
//  ReviewCell.swift
//  Movie
//
//  Created by Sanjeet on 21/04/20.
//  Copyright © 2020 xcode365. All rights reserved.
//

import UIKit

protocol ReviewCellDelegate {
    func didLike(index: Int) -> Void
    func didDislike(index: Int) -> Void
    func didEdit(index: Int) -> Void
    func didRemove(index: Int) -> Void
}

class ReviewCell: UITableViewCell {

    @IBOutlet weak var BtnReply: UIButton!
    @IBOutlet weak var lblcomment: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var BtnDislike: UIButton!
    @IBOutlet weak var BtnLike: UIButton!
    @IBOutlet weak var lbllikes: UILabel!    
    @IBOutlet weak var lblDislikes: UILabel!
    @IBOutlet weak var BtnShare: UIButton!
    @IBOutlet weak var BtnEdit: UIButton!
    @IBOutlet weak var BtnRemove: UIButton!
    
    var delegate: ReviewCellDelegate?
    var index : Int = 0
    
    var minHeight: CGFloat?
    var actualHeight:CGFloat = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgUser.layer.cornerRadius = self.imgUser.frame.height / 2
        self.imgUser.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        guard let minHeight = minHeight else { return size }
        actualHeight = max(size.height, minHeight)
        return CGSize(width: size.width, height: max(size.height, minHeight))
    }
    
    func ConfigureCell(){
        
    }
    
    @IBAction func clickOnLike(_ sender: Any) {
        self.delegate?.didLike(index: self.index)
    }
    
    @IBAction func clickOnDislike(_ sender: Any) {
        self.delegate?.didDislike(index: self.index)
    }
    
    @IBAction func clickOnEdit(_ sender: Any) {
        self.delegate?.didEdit(index: self.index)
    }    

    @IBAction func clickOnRemove(_ sender: Any) {
        self.delegate?.didRemove(index: self.index)
    }
    
}
