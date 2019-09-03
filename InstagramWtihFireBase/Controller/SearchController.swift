//
//  SearchController.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 22/8/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import UIKit
import Firebase

class SearchController:UICollectionViewController,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
    
    
    let cellId = "cellId"
    
    lazy var searchBar:UISearchBar = {
    let searchBar = UISearchBar()
        searchBar.placeholder = "Enter Text"
        searchBar.delegate = self
        UITextField.appearance(whenContainedInInstancesOf:[UISearchBar.self]).backgroundColor = UIColor(white: 0.90, alpha: 0.5)
        return searchBar
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchBar.isHidden = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       self.masterList = self.user.filter { (user) -> Bool in
            return user.username.contains(searchText)
        }
        self.collectionView.reloadData()
    }
    var user = [UserInfo]()
    var masterList = [UserInfo]()
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        self.collectionView.keyboardDismissMode = .onDrag
        guard let nav = navigationController?.navigationBar else {return}
        nav.addSubview(searchBar)
        searchBar.fillSuperview(padding: .init(top: 5, left: 10, bottom: 5, right: 10))
        collectionView.alwaysBounceVertical = true
        collectionView.register(SearchControllerCell.self, forCellWithReuseIdentifier: cellId)
        
        
        Database.database().reference().child("user").observeSingleEvent(of: .value, with: { (snapshot) in
            let dictionary = snapshot.value as? [String:Any]
            dictionary?.forEach({ (key,value) in
                if key == Auth.auth().currentUser?.uid {
                    return
                }
                
                guard   let values = value as? [String:Any] else {return}
                let user = UserInfo(uid: key, dict: values)
                self.user.append(user)
                
            })
            
           self.user =  self.user.sorted(by: { (u1, u2) -> Bool in
                return u1.username.compare(u2.username) == .orderedAscending
            })
            self.masterList = self.user
            self.collectionView.reloadData()
        })
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = self.masterList[indexPath.item]
        self.searchBar.isHidden = true
        //print(user.uid)
        let controller = ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.userid = user.uid
    
        navigationController?.pushViewController(controller, animated: true)
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return masterList.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchControllerCell
       cell.result = self.masterList[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: self.view.frame.width, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 12, left: 12, bottom: 0, right: 0)
    }
}
