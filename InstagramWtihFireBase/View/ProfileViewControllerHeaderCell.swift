//
//  HomeControllerHeaderCell.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 15/8/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import UIKit
import Firebase
import  SDWebImage

class ProfileViewControllerHeaderCell:UICollectionReusableView{
    
    var userid:String?{
        didSet {
            //self.button.isHidden = true
            setupbutton()
            
        }
    }
    
    var user:UserInfo?{
        didSet{
           // print(user?.username ?? "")
            self.username.text = user?.username ?? ""
            self.imageView.sd_setImage(with: URL(string: self.user?.photo_url ?? ""))
        }
    }
    let imageView :UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.constrainWidth(constant: 100)
        imageView.constrainHeight(constant: 100)
        return imageView
    }()
    

    let username = UILabel(text: "Fuad Hasan", font: .boldSystemFont(ofSize: 18),numberofLine: 1)
    let post = UILabel(text: "11", font: .boldSystemFont(ofSize: 15))
    let follower = UILabel(text: "0", font: .boldSystemFont(ofSize: 15))
    let following = UILabel(text: "0", font: .boldSystemFont(ofSize: 15))
    
    let  button:UIButton = {
        let button = UIButton()
       button.setTitle("Edit Profile", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.constrainHeight(constant: 35)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.borderWidth = 0.3
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        button.layer.cornerRadius = 3
        return button
    }()
    
    
    let postlabel = UILabel(text: "posts", font: .boldSystemFont(ofSize: 14))
    let followerlabel = UILabel(text: "followers", font: .boldSystemFont(ofSize: 14))
    let followinglabel = UILabel(text: "following", font: .boldSystemFont(ofSize: 14))
    
    let sep1 :UIView = {
       let sep = UIView()
        sep.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        sep.constrainHeight(constant: 0.5)
        return sep
    }()
    let sep2 :UIView = {
        let sep = UIView()
        sep.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        sep.constrainHeight(constant: 0.5)
        return sep
    }()
   let button1 = UIButton()
   let button2 = UIButton()
   let button3 = UIButton()
    
    
    @objc func handleButton(){
        guard let userId = self.userid else {return}
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        
        let value = [userId:1]

        
        if self.button.currentTitle == "Follow" {
     Database.database().reference().child("follow").child(currentUserId).updateChildValues(value) { (error, ref) in
            if let error = error {
                print("failed to save data",error)
                return
            }
            print("Successfully save follow")
        self.button.setTitle("Unfollow", for: .normal)
        self.button.setTitleColor(.black, for: .normal)
        self.button.backgroundColor = .white

        }
            
        } else {
            Database.database().reference().child("follow").child(currentUserId).removeValue { (error, ref) in
                if let error = error {
                    print("failed to remove data",error)
                    return
                }
                self.button.setTitle("Follow", for: .normal)
                self.button.setTitleColor(.white, for: .normal)
                self.button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                print("Successfully remove follow")
                
            }
        }
        
    }
    
    func  setupbutton(){
        
        guard let userId = self.userid else {return}
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        
      
    Database.database().reference().child("follow").child(currentUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            self.button.isHidden = false
            guard let value = snapshot.value as? Int else {
                self.button.setTitle("Follow", for: .normal)
                self.button.setTitleColor(.white, for: .normal)
                self.button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                return
        }
        
        if value == 1 {
            self.button.setTitle("Unfollow", for: .normal)
            self.button.setTitleColor(.black, for: .normal)
            self.button.backgroundColor = .white
            return
        }
        else {
            self.button.setTitle("Follow", for: .normal)
            self.button.setTitleColor(.white, for: .normal)
            self.button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            
        }
    })
}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
       // setupbutton()
        button1.setImage(#imageLiteral(resourceName: "grid").withRenderingMode(.alwaysTemplate), for: .normal)
        button1.tintColor = UIColor(white: 0.5, alpha: 0.5)
        
        //button1.backgroundColor = .blue
        button2.setImage(#imageLiteral(resourceName: "list").withRenderingMode(.alwaysTemplate), for: .normal)
        button2.tintColor = UIColor(white: 0.5, alpha: 0.5)
        button3.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysTemplate), for: .normal)
        button3.tintColor = UIColor(white: 0.5, alpha: 0.5)

        imageView.backgroundColor = .blue
        username.textAlignment = .center
        post.textAlignment = .center
        follower.textAlignment = .center
        following.textAlignment = .center
        postlabel.textColor = UIColor(white: 0.5, alpha: 0.5)
        postlabel.textAlignment = .center
        followerlabel.textColor = UIColor(white: 0.5, alpha: 0.5)
        followerlabel.textAlignment = .center
        followinglabel.textColor = UIColor(white: 0.5, alpha: 0.5)
        followinglabel.textAlignment = .center
        
        
        
        
        let postButtonStack = UIStackView(arrangedSubView: [VerticalStackView(views: [post,postlabel], spacing: 2),VerticalStackView(views: [follower,followerlabel], spacing: 2),VerticalStackView(views: [following,followinglabel], spacing: 2)], spacing: 15)
        postButtonStack.distribution = .fillEqually
        let v2StackView = VerticalStackView(views: [UIView(),postButtonStack,button], spacing: 10)
        let stackView = UIStackView(arrangedSubView: [imageView,v2StackView], spacing: 10)
        let stack = UIStackView(arrangedSubView: [stackView,v2StackView], spacing: 5)
        let bview = UIStackView(arrangedSubView: [button1,button2,button3], spacing: 0)
        bview.distribution = .fillEqually
        let fstack = VerticalStackView(views: [stack,UIStackView(arrangedSubviews: [username,UIView()])], spacing: 12)
        addSubview(fstack)
        fstack.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 12, left: 12, bottom: 12, right: 12),size:.init(width: 0, height: 140))
        
        let sView = VerticalStackView(views: [sep1,bview,sep2], spacing: 10)
        addSubview(sView)
        sView.anchor(top: fstack.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIStackView{
    convenience init(arrangedSubView:[UIView],spacing:CGFloat){
        self.init(arrangedSubviews: arrangedSubView)
        self.spacing = spacing
    }
}

extension UILabel{
    convenience  init(text:String,font:UIFont,numberofLine:Int=0) {
        self.init(frame:.zero)
        self.text = text
        self.font = font
        self.numberOfLines = numberofLine
    }
}

extension UIButton{
    
    convenience init(cornerRadius:CGFloat=0){
        self.init(type:.system)
        self.layer.cornerRadius = cornerRadius
    }
}
