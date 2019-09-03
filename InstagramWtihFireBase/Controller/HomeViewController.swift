//
//  HomeViewController.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 21/8/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import UIKit
import Firebase



class HomeViewController:UICollectionViewController,UICollectionViewDelegateFlowLayout{
    
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
      
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.register(HomeViewControllerCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.refreshControl = refreshController
        NotificationCenter.default.addObserver(self, selector: #selector(handleObserve), name: PhotoShareController.name, object: nil)
        
         navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
        fetch_user()
        followerUserPost()

    }
    
    
    @objc func handleCamera(){
        
        let controller = CameraController()
        // controller.view.backgroundColor = .red
        present(controller, animated: true, completion: nil)
    }

    
    @objc func handleObserve(){
        handleRefresh()
    }
    
    @objc func handleRefresh(){
        
        print("handle Refresh")
        post.removeAll()
        fetch_user()
        followerUserPost()
    }
    
    
    var userInfo:UserInfo?
    
    var post = [UserPost]()
    

    fileprivate func followerUserPost(){
        
        guard  let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("follow").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard  let value = snapshot.value as? [String:Any] else {return}
            value.forEach({ (arg) in
                
                let (key, _) = arg
                
                print(key)
                Database.database().reference().child("post").child(key).observeSingleEvent(of: .value, with: { (snashot) in
                    
                  guard  let value = snapshot.value as? [String:Any] else {return}
                    
                    value.forEach({ (key,value) in
                        
                        Database.fetchUserWithUid(uid: key, completion: { (user, error) in
                            if let error = error {
                                print("error",error)
                                return
                            }
                            if let user = user {
                            self.fetchPostWithUser(user: user)
                                
                            }
                        })
                    })
                    
                }, withCancel: { (error) in
                    print("failed to fetch follwed user post",error)
                })
            })
            
        }) { (error) in
            print("Failed to fetch followed user data ",error)
        }
    }
    
    
 
    
    fileprivate func fetch_user(){
    
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.fetchUserWithUid(uid: uid) { user,error  in
            
            if let error = error {
                print("Failed to fetch userPost and userInfo",error)
            }
            guard let user = user else {return}
            self.fetchPostWithUser(user: user)
        }
            
    }
    
    
    
    fileprivate func fetchPostWithUser(user:UserInfo){
        self.collectionView.refreshControl?.endRefreshing()

        Database.database().reference().child("post").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // print(snapshot.value ?? "")
            guard let value = snapshot.value as? [String:Any] else {return}
            
            value.forEach({(key,value) in
                
                guard let values = value as? [String:Any] else {return}
                let userPost = UserPost(user: user, dict:values)
                self.post.append(userPost)
                self.collectionView.reloadData()
                
            })
            
            self.post.sort(by: { (p1, p2) -> Bool in
                p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            
        })
    }
   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.post.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeViewControllerCell
        if indexPath.item < post.count {
        cell.result = self.post[indexPath.item]
        }
        
      
       // cell.backgroundColor = .red
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 7, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let dummycell = HomeViewControllerCell(frame: .init(x: 0, y: 0, width: 0, height: 1000))
      
        if indexPath.item < post.count {
        dummycell.result = self.post[indexPath.item]
        }
        let size = dummycell.systemLayoutSizeFitting(.init(width: 0, height: 1000))
        dummycell.layoutIfNeeded()
        
        return .init(width: view.frame.width, height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
