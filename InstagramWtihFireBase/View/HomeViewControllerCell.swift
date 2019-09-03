//
//  HomeViewControllerCell.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 21/8/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import UIKit

class HomeViewControllerCell:UICollectionViewCell{
    

    var result:UserPost?{
        didSet{
            
            userName.text = result?.user.username
            postPic.sd_setImage(with: URL(string: result?.imageurl ?? ""))
            userpic.sd_setImage(with: URL(string:result?.user.photo_url ?? ""))
            setupAttributedText()
      
        }
    }
    
    fileprivate func setupAttributedText(){
        
        guard let result = self.result else {return}

        let attributedText = NSMutableAttributedString(string: "\(result.user.username) ", attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        
        
        
        
       attributedText.append(NSAttributedString(string: result.posttext, attributes: [.font:UIFont.systemFont(ofSize: 14)]))
        
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [.font: UIFont.systemFont(ofSize: 4)]))
        
        attributedText.append(NSAttributedString(string: result.creationDate.timeAgoDisplay(), attributes: [.font:UIFont.systemFont(ofSize: 12),.foregroundColor:UIColor(white: 0.2, alpha: 0.5)]))
        
       captionWithUserName.attributedText = attributedText
        
    }
    
    let userName:UILabel = {
        let lvl = UILabel()
        lvl.text  = ""
        lvl.font = UIFont.boldSystemFont(ofSize: 14)
        return lvl
    }()
    
    let userpic:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.constrainHeight(constant:  40)
        image.constrainWidth(constant: 40)
        image.backgroundColor = .purple
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        return image
    }()
    
    let commentButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    let likeButton : UIButton = {
       let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    let shareButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    
    
    let profileButton :UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.constrainHeight(constant: 50)
        return button
    }()
    
    let dotButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
        
    }()
    
    let postPic:UIImageView = {
        let image = UIImageView()
        image.constrainWidth(constant: 500)
        image.constrainHeight(constant: 500)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let captionWithUserName:UILabel = {
        
        let label = UILabel()
        
       
        label.numberOfLines = 0
        return label
    
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        backgroundColor = .white
        let firstStackView = UIStackView(arrangedSubView: [userpic,userName,dotButton], spacing: 7)
        addSubview(firstStackView)
        firstStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 10, bottom: 0, right: 10),size: .init(width: 0, height: 80))
        firstStackView.alignment = .center
        
        addSubview(postPic)
         postPic.anchor(top: firstStackView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        let stackView =  UIStackView(arrangedSubView: [ likeButton,commentButton,shareButton,UIView(),profileButton ], spacing: 14)
        let secondStackView = VerticalStackView(views: [stackView,captionWithUserName], spacing: 10)
        addSubview(secondStackView)
        
        secondStackView.anchor(top: postPic.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 5, left: 10, bottom: 0, right: 10))
      
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
