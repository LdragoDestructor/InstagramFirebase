//
//  imageCollectionController.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 19/8/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import UIKit
import Photos


class ImageCollectionController:UICollectionViewController,UICollectionViewDelegateFlowLayout{
    

    
    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(imageCollectionControllerCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(imageCollectionControllerHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleShare))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleDismiss))
        navigationController?.navigationBar.tintColor = .black
        
        fetchPhotos()
        
    }
    
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    var image = [UIImage]()
    var assests = [PHAsset]()
    func fetchPhotos(){
        
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                let fetchOption = PHFetchOptions()
                fetchOption.fetchLimit = 50
                let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
                fetchOption.sortDescriptors = [sortDescriptor]
                let allphotos = PHAsset.fetchAssets(with: .image, options: fetchOption)
                allphotos.enumerateObjects ({ (assets, count, stop) in
                    print(assets)
                    self.assests.append(assets)
                    let options = PHImageRequestOptions()
                    options.isSynchronous = true
                    let target = CGSize(width: 300, height: 300)
                    
                    let manager = PHImageManager()
                    manager.requestImage(for: assets, targetSize: target, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                        if let image = image{
                            self.image.append(image)
                        }
                        
                        if count == allphotos.count - 1 {
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()

                            }
                        }
                        
                    })
                })
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                // Should not see this when requesting
                print("Not determined yet")
            @unknown default:
                fatalError()
            }
        }
        
        
        
        
        
    
    }
    @objc func handleShare(){
        let controller = PhotoShareController()
        
       if let image = selectedImage {
          controller.image = image
        }
        self.navigationController?.pushViewController(controller, animated: true)

    }
    
    @objc func handleDismiss(){
     dismiss(animated: true, completion: nil)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return image.count
    }
    var header:imageCollectionControllerCell?

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! imageCollectionControllerHeaderCell
        
        
        if let selectedImage = selectedImage {
            if let index = self.image.firstIndex(of:selectedImage){
                let selectedAssests = self.assests[index]
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                let target = CGSize(width: 800, height: 800)
                let manager = PHImageManager()
                manager.requestImage(for:selectedAssests , targetSize: target, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                      self.selectedImage = image
                })
            
            }
        }
        
        
        cell.imageView.image = self.selectedImage
       // cell.backgroundColor = .purple
        return cell
    }
    
    var selectedImage:UIImage?
    var headerImages = [UIImage]()
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedImage = self.image[indexPath.item]
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        self.collectionView.reloadData()

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 400)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! imageCollectionControllerCell
        cell.imageView.image = self.image[indexPath.item]
        cell.backgroundColor = .red
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (view.frame.width - 3) / 4, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
