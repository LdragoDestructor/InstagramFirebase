//
//  imageCollectionControllerHeaderCell.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 20/8/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import UIKit

class imageCollectionControllerHeaderCell:UICollectionViewCell{
    
    
    let imageView :UIImageView = {
        let image = UIImageView()
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
