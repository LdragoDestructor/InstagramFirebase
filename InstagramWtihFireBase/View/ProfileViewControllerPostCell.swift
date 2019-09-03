//
//  ProfileViewControllerPostCell.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 21/8/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import UIKit

class ProfileViewControllerPostCell:UICollectionViewCell{
    
    
    let imageView:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
