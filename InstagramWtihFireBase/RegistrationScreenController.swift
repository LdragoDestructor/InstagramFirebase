//
//  RegistrationScreenController.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 15/8/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import UIKit
import Firebase

class RegistrationScreenController:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    let picButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(imagePicker), for:.touchUpInside)
        button.clipsToBounds = true
        return button
        
    }()
    
    let EmailTextFiled:UITextField = {
        let textFiled = UITextField()
        textFiled.placeholder = "Email"
        //textFiled.layer.cornerRadius = 8
        textFiled.borderStyle = .roundedRect
        textFiled.backgroundColor = UIColor(white: 0.95, alpha: 0.5)
        textFiled.addTarget(self, action: #selector(handleError), for: .editingChanged)
        return textFiled
    }()
    
    let UserNameFiled:UITextField = {
        let textFiled = UITextField()
        textFiled.placeholder = "UserName"
        textFiled.borderStyle = .roundedRect
        textFiled.layer.cornerRadius = 8
        textFiled.backgroundColor = UIColor(white: 0.95, alpha: 0.5)
        textFiled.addTarget(self, action: #selector(handleError), for: .editingChanged)
        return textFiled
    }()
    
    let PasswordTextFiled:UITextField = {
        let textFiled = UITextField()
        textFiled.placeholder = "Password"
        textFiled.borderStyle = .roundedRect
        textFiled.backgroundColor = UIColor(white: 0.95, alpha: 0.5)
        textFiled.addTarget(self, action: #selector(handleError), for: .editingChanged)
        textFiled.isSecureTextEntry = true
        return textFiled
    }()
    
    let nextButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.addTarget(self, action: #selector(handle), for: .touchUpInside)
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.isEnabled = false
        return button
    }()
    
    let accountButton:UIButton = {
        
        let button = UIButton()
        let attributedText = NSMutableAttributedString(string: "Already have an account. ", attributes:[ NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        attributedText.append(NSAttributedString(string: "Sign in", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.init(red: 17/255, green: 180/255, blue: 237/255, alpha: 1)]))
        button.addTarget(self, action: #selector(handlePop), for: .touchUpInside)
        button.setAttributedTitle(attributedText, for: .normal)
        
        return button
    }()
    
    @objc func handlePop(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        setupButton()
        textFieldAndButton()
        view.addSubview(accountButton)
        accountButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 15, right: 0))
    }
    
    @objc func imagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
        imagePicker.delegate = self
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.picButton.setImage(originalImage.withRenderingMode(.alwaysOriginal) , for: .normal)
        }
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.picButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleError(){
        
        if let email = EmailTextFiled.text,!email.isEmpty, let username = UserNameFiled.text,!username.isEmpty,let password = PasswordTextFiled.text,!password.isEmpty {
            self.nextButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            self.nextButton.isEnabled = true
        }
        else{
            self.nextButton.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            self.nextButton.isEnabled = false
            
        }
     
    }
    
    var user:UserInfo?
    @objc func handle() {
        
        guard let email = EmailTextFiled.text else{return}
        guard let password = PasswordTextFiled.text else{return}
        guard let username = UserNameFiled.text else {return}
        
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user:AuthDataResult?, error) in
            if let error = error {
                print("Failed to create user",error)
                return
            }
           // print ("successfully create user",user?.user.uid ?? "")
            
            
            
            guard let image  = self.picButton.imageView?.image else {return}
            guard let dataMedia = image.jpegData(compressionQuality: 0.3) else{return}
            let id = NSUUID().uuidString
            
    
            let storageRef = Storage.storage().reference().child("photo_url").child(id)
            storageRef.putData(dataMedia, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    print("Failed to upload image",error)
                    return
                }
                
                print("Successfully save image to Storage")
                storageRef.downloadURL(completion: { (downlordUrl, error) in
                    if let error = error {
                        print("Failed to downlord imageUrl",error)
                        return
                    }
               //     print("Successfully downlord imageUrl",downlordUrl?.absoluteString ?? "")
                    
                    guard let imageUrl = downlordUrl?.absoluteString else {return}
                    guard let uid = user?.user.uid else{return}
                    let data = ["email":email,"username":username,"photo_url":imageUrl]
                    
                    
                    Database.database().reference().child("user").child(uid).updateChildValues(data, withCompletionBlock: { (error, ref) in
                        if let error = error {
                            print("Failed to Save data to the database",error)
                            return
                        }
                 //       print("Successfully save data to the database")
                        guard let controller =  UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
                        controller.setupController()
                       self.dismiss(animated: true, completion: nil)
                    })

                })
                
            })
        }
        
    }

    
    
    
    fileprivate func setupButton(){
        view.addSubview(picButton)
        picButton.centerXInSuperview()
        picButton.anchor(top: view.topAnchor, leading: nil, bottom: nil , trailing: nil,padding: .init(top: 60, left: 0, bottom: 0, right: 0),size:.init(width: 150, height: 150))
        self.picButton.layer.cornerRadius = 75
        
    }
    
    
    
    fileprivate func textFieldAndButton(){
        let stackView = UIStackView(arrangedSubviews: [EmailTextFiled,UserNameFiled,PasswordTextFiled,nextButton])
        view.addSubview(stackView)
        stackView.anchor(top: picButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 40, left: 30, bottom: 0, right: 30),size: .init(width: 0, height: 200))
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        
    }
    
    
}
