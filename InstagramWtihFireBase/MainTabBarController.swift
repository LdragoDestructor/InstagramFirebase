//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 15/8/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController:UITabBarController,UITabBarControllerDelegate {
    
    var user:UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            let controller = LoginController()
            DispatchQueue.main.async {
                self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
            }
            return
        }
        
        setupController()
        self.delegate = self
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.firstIndex(of:viewController)
        
        if index == 2 {
            
            let controller = ImageCollectionController(collectionViewLayout:UICollectionViewFlowLayout())
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    fileprivate func userCheck() {
   
        
    }
    
     func setupController(){
        
        viewControllers = [
            
            
            
            createTabBar(rootController: ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout()), selectedImage: #imageLiteral(resourceName: "profile_selected"), unselectedImage: #imageLiteral(resourceName: "profile_unselected")),

            createTabBar(rootController: HomeViewController(collectionViewLayout: UICollectionViewFlowLayout()), selectedImage: #imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected")),
            
            
             createTabBar(rootController: UIViewController(), selectedImage: nil, unselectedImage: #imageLiteral(resourceName: "plus_unselected")),
             
             createTabBar(rootController: SearchController(collectionViewLayout: UICollectionViewFlowLayout()), selectedImage: #imageLiteral(resourceName: "search_selected"), unselectedImage: #imageLiteral(resourceName: "search_unselected")),
             
            
            
            createTabBar(rootController: UIViewController(), selectedImage: #imageLiteral(resourceName: "like_selected"), unselectedImage: #imageLiteral(resourceName: "like_unselected") ),
            
        ]
        
        
       // guard let item = tabBar.items else {return}
        
        tabBar.items?.forEach({ (item) in
            item.imageInsets = .init(top: 4, left: 0, bottom: -15, right: 0)
        })
    }

    
    fileprivate func createTabBar(rootController:UIViewController,selectedImage:UIImage?,unselectedImage:UIImage ) -> UIViewController{
           let navControlller = UINavigationController(rootViewController: rootController)
            rootController.view.backgroundColor = .white
            navControlller.tabBarItem.selectedImage = selectedImage
            navControlller.tabBarItem.image = unselectedImage
            return navControlller
    }
}
