//
//  PhotoShareController.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 20/8/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import UIKit
import Firebase

class PhotoShareController:UIViewController{
    
    var image:UIImage?{
        didSet{
            self.imageView.image = image
             }
    }
    
    let containerView:UIView = {
        let view = UIView()
        return view
    }()
    
    let imageView:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    
    let textField:UITextView = {
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 18)
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewandTextfield()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        navigationController?.navigationBar.tintColor = .black
    }
    
    static let name = NSNotification.Name(rawValue: "name")
    fileprivate func saveDatawithUrl(imageUrl:String){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard  let value = self.textField.text else {return}
        guard let image = self.image else {return}
        
        print(image)
        
        let values = ["posttext":value,"imageurl":imageUrl,"creationDate":Date().timeIntervalSince1970,"imageWidth":image.size.width,"imageHeight":image.size.height] as [String : Any]
        
        Database.database().reference().child("post").child(uid).childByAutoId().updateChildValues(values, withCompletionBlock: { (error, ref) in
            if let error = error {
                print("failed to save data",error)
                return
            }
            print("Successfully save data to the database")
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: PhotoShareController.name, object: nil)
            
        })
        
    }
    
    @objc func handleShare() {
        let filename = NSUUID().uuidString
        guard  let image = self.imageView.image else {return}
        
        guard  let data = image.jpegData(compressionQuality: 0.5) else {return}
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        Storage.storage().reference().child("post_photo").child(filename).putData(data, metadata: nil) { (image, error) in
            if let error = error {
                print("Failed to put data",error)
                return
            }
            print("Successfully save image")
            
            Storage.storage().reference().child("post_photo").child(filename).downloadURL(completion: { (downlordUrl, error) in
                if let error = error {
                    print("failed to downlord data",error)
                }
                print("Successfully downlord url",downlordUrl?.absoluteString ?? "")
                guard let imageUrl = downlordUrl?.absoluteString else {return}
                
                self.saveDatawithUrl(imageUrl: imageUrl)
        
            })
            
         }
        
    }
    
    fileprivate func setupViewandTextfield(){
        
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,size:.init(width: 0, height: 150))
        containerView.backgroundColor = .white
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: nil,padding: .init(top: 10, left: 10, bottom: 10, right: 10),size:.init(width: 150, height: 0))
        imageView.backgroundColor = .blue
        containerView.backgroundColor = .white
        containerView.addSubview(textField)
        textField.anchor(top: containerView.topAnchor, leading: imageView.trailingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor,padding: .init(top: 10, left: 10, bottom: 10, right: 0))
        textField.backgroundColor = .white
    }
    
    
}
