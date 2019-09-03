//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 16/8/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import UIKit
import Firebase

class LoginController:UIViewController{
    
    
    
    let headerView:UIView = {
       let headerView = UIView()
        return headerView
    }()
    
    let imageView :UIImageView = {
     let imageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white").withRenderingMode(.alwaysOriginal))
        imageView.contentMode  = .scaleAspectFill
        return imageView
        
        
    }()
    
    let signUpButton:UIButton = {
        let button = UIButton()
        button.setTitle("Don't have an account?  Sign Up.", for: .normal)
        
        
        let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "Sign up", attributes: [.foregroundColor:UIColor.init(red: 17/255, green: 180/255, blue: 237/255, alpha: 1),NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)]))
        
        button.setAttributedTitle(attributedText, for: .normal)
            
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handle) ,for: .touchUpInside)
        return button
    }()
    
    
    
    let EmailTextFiled:UITextField = {
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
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.addTarget(self, action: #selector(handleTarget), for: .touchUpInside)
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.isEnabled = false
        return button
    }()
    
    
    @objc func handleError(){
        
        if  let username = EmailTextFiled.text,!username.isEmpty,let password = PasswordTextFiled.text,!password.isEmpty {
            self.nextButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            self.nextButton.isEnabled = true
        }
            
        else{
            self.nextButton.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            self.nextButton.isEnabled = false
            
        }
        
    }
    
    @objc func handleTarget (){
        
        
        
        guard let email = EmailTextFiled.text else {return}
        guard let password = PasswordTextFiled.text else {return}
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Failed to login",error)
                return
            }
            print("Successfully login",user?.user.uid ?? "")
            guard let controller =  UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
            controller.setupController()
            self.dismiss(animated: true, completion: nil)

        }
        
        
        
    }
    
    
    @objc func handle(){
        let controller = RegistrationScreenController()
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(headerView)
        headerView.anchor(top: view.topAnchor, leading: view.leadingAnchor , bottom: nil, trailing: view.trailingAnchor,size:.init(width: 0, height: 200))
        headerView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        headerView.addSubview(imageView)
        imageView.centerInSuperview(size: .init(width: 75, height: 75))
        
        let stackView = VerticalStackView(views: [EmailTextFiled,PasswordTextFiled,nextButton], spacing: 10)
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        stackView.centerXInSuperview()
        stackView.anchor(top: headerView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 25, left: 20, bottom: 0, right: 20),size:.init(width: 0, height: 150))
        stackView.spacing = 10
        
        self.navigationController?.navigationBar.isHidden = true
        view.addSubview(signUpButton)
       // let height = UIApplication.shared.statusBarFrame.height
        signUpButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 15, right: 0))
    }
}
