//
//  SearchControllerCell.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 23/8/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import UIKit

class SearchControllerCell:UICollectionViewCell{
    
    
    var result:UserInfo!{
        
        didSet{
            self.username.text = result.username
            self.imageView.sd_setImage(with: URL(string: result.photo_url))
        }
    }
    
    
    let imageView:UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 30
        image.constrainWidth(constant: 60)
        image.constrainHeight(constant: 60)
        image.clipsToBounds = true
        image.backgroundColor = .blue
        return image
    }()
    
    let username:UILabel = {
        let name = UILabel()
        name.text = "UserName"
        name.font = UIFont.boldSystemFont(ofSize: 16)
        return name
    }()
    
    let seperator:UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let hstackView = UIStackView(arrangedSubView: [imageView,username], spacing: 5)
        
        addSubview(hstackView)
        
        addSubview(seperator)
        seperator.anchor(top: username.bottomAnchor, leading: username.leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 20, left: 0, bottom: 0, right: 0),size:.init(width: 0, height: 0.5))
        hstackView.alignment = .center
        hstackView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
