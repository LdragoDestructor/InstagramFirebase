//
//  imageCollectionControllerCell.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 20/8/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import UIKit

class imageCollectionControllerCell:UICollectionViewCell{
    
    
    let imageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
