//
//  CameraController.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 26/8/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import UIKit
import AVFoundation


let capturebutton :UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "capture_photo"), for: .normal)
    return button
}()
let arrowButton:UIButton = {
    
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
    return button
}()

class CameraController:UIViewController,AVCapturePhotoCaptureDelegate,UIViewControllerTransitioningDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
       // view.backgroundColor = .red
        captureSession()
        capturebutton.addTarget(self, action: #selector(handlePhoto), for: .touchUpInside)
        view.addSubview(capturebutton)
        capturebutton.centerXInSuperview()
        capturebutton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: 10, right: 0),size: .init(width: 80, height: 80))
        
        view.addSubview(arrowButton)
        arrowButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 5, left: 0, bottom: 0, right: 0),size: .init(width: 80, height: 80))
        arrowButton.addTarget(self, action: #selector(handledis), for: .touchUpInside)
        
        transitioningDelegate = self
        
    }
   
    @objc func handledis(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func handlePhoto(){
        
        let capturePhotoSettings = AVCapturePhotoSettings()
        output.capturePhoto(with: capturePhotoSettings, delegate: self)
    
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let controller = Transitionpresent()
        return controller
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionDismiss()  
        
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        let image = UIImage(data: imageData!)
        let anotherView = CaptureView()
        self.view.addSubview(anotherView)
        anotherView.fillSuperview()
        anotherView.imageView.image = image
        anotherView.cancenlButton.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        anotherView.saveButton.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    let output = AVCapturePhotoOutput()

    func captureSession(){

        let captureSession = AVCaptureSession()
        
        //1. setup inputs
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let err {
            print("Could not setup camera input:", err)
        }
        
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        //3. setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        captureSession.startRunning()
        
    }
    
    
    
    
}
