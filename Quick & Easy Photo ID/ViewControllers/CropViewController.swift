//
//  CropViewController.swift
//  Quick & Easy Photo ID
//
//  Created by Nirav Gondaliya on 08/05/18.
//  Copyright © 2018 Nirav Gondaliya. All rights reserved.
//

import UIKit
import IGRPhotoTweaks

class CropViewController: IGRPhotoTweakViewController {
    
    @IBOutlet weak var imgMask: UIImageView!
    var selectedRatio:String?
    var country:String?
    var selectedType:String?
    var picker:UIImagePickerController?=UIImagePickerController()
    @IBOutlet weak var lblSubTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        picker?.delegate = self
        self.addNavBackBtn()
        navigationItem.title = self.country
        self.lblSubTitle.text = self.selectedType
        self.setCropAspectRect(aspect: CropUser.shared.ratio)
        self.lockAspectRatio(true)
        //imgMask.ratio
        IGRCropCornerLine.appearance().backgroundColor = UIColor.clear
        IGRCropLine.appearance().backgroundColor = UIColor.clear
        IGRCropGridLine.appearance().backgroundColor = UIColor.clear
        IGRCropCornerLine.appearance().backgroundColor = UIColor.clear
        IGRCropMaskView.appearance().backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func onBtnCropClick(_ sender: UIButton) {
        self.cropAction()
    }
    
    @IBAction func onBtnCancelClick(_ sender: UIButton) {
        self.showOptionForImage()
      //  self.dismissAction()
    }
    
    func addNavBackBtn(){
        
        let btn = UIButton (frame: CGRect (x: 0, y: 0, width: 35, height: 35))
        btn.setImage(#imageLiteral(resourceName: "img_Back"), for: .normal)
        btn.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        let barBtn = UIBarButtonItem (customView: btn)
        
        self.navigationItem.leftBarButtonItems = [barBtn]
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showOptionForImage() {
        let alert = UIAlertController (title: nil, message: nil, preferredStyle: .actionSheet)
        let btnCamera = UIAlertAction (title: "Camera", style: .default) { (action) in
            DispatchQueue.main.async {
                self.openCamera()
            }
        }
        let btnGalary = UIAlertAction (title: "Open Photos", style: .default) { (action) in
            DispatchQueue.main.async {
                self.openLibrary()
            }
        }
        let btnCancel = UIAlertAction (title: "Cancel", style: .cancel) { (action) in
        }
        
        alert.addAction(btnCamera)
        alert.addAction(btnGalary)
        alert.addAction(btnCancel)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension CropViewController : IGRPhotoTweakViewControllerDelegate {
    func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage) {
        CropUser.shared.image = croppedImage
        let editVC = EditImageViewController.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(editVC, animated: true)
    }

    func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CropViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func openLibrary() {
        
        Utility.getPhotoLibraryAuthorizationStatus { (status, error) in
            if status {
                self.picker?.sourceType = .photoLibrary
                self.present(self.picker!, animated: true, completion: nil)
            }
        }
    }
    
    func openCamera() {
        Utility.getCameraAuthorizationStatus { (status, error) in
            if status {
                self.picker?.sourceType = .camera
                self.present(self.picker!, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let cropVC = CropViewController.instantiate(fromAppStoryboard: .Main)
        DispatchQueue.main.async { [unowned self] in
            self.image = image
            CropUser.shared.image = image
            self.resetView()
            self.setupThemes()
            
//            CropUser.shared.ratio = Constants.schengenAspectRatioList[0]
//
//            cropVC.image = image
//            cropVC.country = Constants.countrySchengen
//            cropVC.selectedType = Constants.schengenList[0]
//            picker.dismiss(animated: true) {
//
//            }
        }
        
        
        picker.dismiss(animated: true) {
           //  self.navigationController?.pushViewController(cropVC, animated: true)
        }
    }
}


