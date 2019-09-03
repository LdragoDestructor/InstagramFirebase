//
//  HomeViewController.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 15/8/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage



class ProfileViewController:UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    
    var userid:String?
    
    let headerId = "headerId"
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(ProfileViewControllerHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView.register(ProfileViewControllerPostCell.self, forCellWithReuseIdentifier: cellId)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        
        fetch_User()
        fetchOrderedPost()
    }
    var post = [UserPost]()
    
    
    fileprivate func fetch_User(){
        
        let uid = self.userid ??  Auth.auth().currentUser?.uid ?? ""
        
     
        
        Database.fetchUserWithUid(uid: uid) { (user,error)  in
            
            if let error = error {
                print("Failed to fecth user",error)
                return
            }
            self.userInfo = user
            self.collectionView.reloadData()
        }
    }

    

    @objc func handleDismiss(){
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do{
                
            try Auth.auth().signOut()
                let controller = UINavigationController(rootViewController: LoginController())
                self.present(controller, animated: true, completion: nil)
                
            } catch {
                
                print("Failed to signout")
            }
            
        }))
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }

    
    
    var userInfo:UserInfo?
    
    fileprivate func fetchOrderedPost(){
        let uid = userid ??  Auth.auth().currentUser?.uid ?? ""
        let ref = Database.database().reference().child("post").child(uid)
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            let user = UserInfo(uid:uid,dict: ["username":"", "photo_url":""])
            guard let value = snapshot.value as? [String:Any] else {return}
            let userPost = UserPost(user:user,dict: value)
            self.post.insert(userPost, at: 0)
            self.collectionView.reloadData()

        })
        { (error) in
            print("Failed to fetch data")
        }

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.post.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as!
            ProfileViewControllerPostCell
        cell.imageView.sd_setImage(with: URL(string: self.post[indexPath.item].imageurl))
        
        
    
        cell.backgroundColor = .purple
        cell.layer.borderWidth = 0.5
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (view.frame.width - 2) / 3, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    


 
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! ProfileViewControllerHeaderCell
    
        
        
        
        cell.user = self.userInfo
        cell.userid = self.userid
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 230)
    }
    
    

    
    
    
//    init(){
//        super.init(collectionViewLayout: UICollectionViewFlowLayout())
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
        
}
    


