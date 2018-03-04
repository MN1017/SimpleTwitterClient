//
//  FollowersGridCollectionViewCell.swift
//  SimpleTwitterClient
//
//  Created by Mohamed Nasser on 3/1/18.
//  Copyright © 2018 Intcore. All rights reserved.
//

import UIKit
import Kingfisher

class FollowersGridCollectionViewCell: UICollectionViewCell {
    
    /// IBOutlet
    ///
    @IBOutlet weak var userImageView: CustomUIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var userBioLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        updateConstraint()
    }
}

/// MARK: Helper Methods
///
extension FollowersGridCollectionViewCell{
    
    /// use this method to set cell ui values
    ///
    func set(user: User){
        self.userNameLabel.text = user.name
        self.userHandleLabel.text = user.userName
        self.userBioLabel.text = user.bio
        self.userImageView.kf.setImage(with: URL(string: user.profileImageURL),placeholder: #imageLiteral(resourceName: "user"))
    }
    
    /// use this method to update constraint to be fit of content size
    ///
    func updateConstraint(){
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthConstraint.constant = ( screenWidth - (4 * 12) ) / 2
    }
}
