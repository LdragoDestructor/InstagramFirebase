//
//  CaptureView.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 2/9/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import UIKit
import Photos

class CaptureView:UIView {
    
    
    let imageView :UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let saveButton :UIButton = {
        let button = UIButton (type: .system)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    let cancenlButton:UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handle), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSave(){
        
        guard let image = imageView.image else {return}
        
                   let library = PHPhotoLibrary.shared()
                    library.performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                         })
              { (success, error) in
                if let error = error {
                    print("Error",error)
                }
                print("Successfully save photo to photoLibrary")
            
                
                DispatchQueue.main.async {
                let label = UILabel()
                label.text = "Save Successfully"
                self.addSubview(label)
                label.centerInSuperview(size: .init(width: 200, height: 200))
                    label.backgroundColor = UIColor(white: 0, alpha: 0.3)
                    label.textAlignment = .center
                    label.textColor = .white
                label.layer.transform = CATransform3DMakeScale(0, 0, 0)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    label.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }, completion: { (_) in
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        label.layer.transform = CATransform3DMakeScale(0.3, 0.3, 0.3)
                       label.alpha = 0
                    }, completion: { (_) in
                        label.removeFromSuperview()
                    })
                    
                })
                
            }
            
        }

       
        
    }
    
    @objc func handle(){
        
        self.removeFromSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        addSubview(imageView)
        imageView.fillSuperview()
        addSubview(saveButton)
        saveButton.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil,padding: .init(top: 0, left: 5, bottom: 5, right: 0),size:.init(width: 80, height: 80))
        addSubview(cancenlButton)
        cancenlButton.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 5, left: 5, bottom: 0, right: 0),size: .init(width: 80, height: 80))
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    
    }
}
