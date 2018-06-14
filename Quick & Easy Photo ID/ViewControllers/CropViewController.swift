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
    
    
    @IBOutlet weak var btnPhotoType : UIButton!
    @IBOutlet var leadingC: NSLayoutConstraint!
    @IBOutlet var trailingC: NSLayoutConstraint!
    @IBOutlet weak var btnMenu : UIBarButtonItem!
    
    @IBOutlet var ubeView: UIView!
  
    @IBOutlet weak var lblSubTitle: UILabel!
    
    var selectedRatio:String?
    var country:String?
    var selectedType:String?
   
    var hamburgerMenuIsVisible = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
      
        
        self.resetView()
        self.setupThemes()
        self.addNavBackBtn()
       
        self.lblSubTitle.text = self.selectedType
        print(CropUser.shared.ratio)
        self.setCropAspectRect(aspect: CropUser.shared.ratio)
        self.lockAspectRatio(true)
        //imgMask.ratio
        
        self.stopChangeAngle()
        
        
        if let country = country{
            self.btnPhotoType.setTitle(country, for: .normal)
        }
    
         self.leadingC.constant = self.view.frame.size.width
        
        
//        IGRCropCornerLine.appearance().backgroundColor = UIColor.orange
//        IGRCropLine.appearance().backgroundColor = UIColor.yellow
//        IGRCropGridLine.appearance().backgroundColor = UIColor.black
//        IGRCropCornerLine.appearance().backgroundColor = UIColor.white
//        IGRCropMaskView.appearance().backgroundColor = UIColor.black
        
    }
    
    @IBAction func hamburgerBtnTapped(_ sender: Any) {
        //if the hamburger menu is NOT visible, then move the ubeView back to where it used to be
        if !hamburgerMenuIsVisible {
            leadingC.constant = leadingC.constant - 250
            //this constant is NEGATIVE because we are moving it 150 points OUTWARD and that means -150
            //trailingC.constant = -150
            
            //1
            hamburgerMenuIsVisible = true
        } else {
            //if the hamburger menu IS visible, then move the ubeView back to its original position
            leadingC.constant = self.view.frame.size.width
            // trailingC.constant = 0
            
            //2
            hamburgerMenuIsVisible = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            print("The animation is complete!")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

 
    
    @IBAction func btnAcceptedTapped(_ sender: UIButton) {
        self.cropAction()
        
    }
    
    
    @IBAction func btnSaveToGalleryTapped(_ sender : UIButton){
        self.hamburgerBtnTapped(self.btnMenu)
        self.btnAcceptedTapped(UIButton())
        
    }
    @IBAction func btnPrintTapped(_ sender : UIButton){
        self.hamburgerBtnTapped(self.btnMenu)
        
        CropUser.shared.editedImage = self.image
        
        let homeVC = HomeViewController.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(homeVC, animated: true)
        
    }
    @IBAction func btnShareApplicationTapped(_ sender : UIButton){
        self.hamburgerBtnTapped(self.btnMenu)
        
        let textToShare = "Download Quick & Easy photo ID"
        
        if let myWebsite = URL(string: "http://www.google.com/") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
        
    }
    @IBAction func btnRetakePhotoTapped(_ sender : UIButton){
        self.hamburgerBtnTapped(self.btnMenu)
        self.goBack()
        
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
    
    
}

extension CropViewController : IGRPhotoTweakViewControllerDelegate {
    func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage) {
        CropUser.shared.image = croppedImage
//        let editVC = EditImageViewController.instantiate(fromAppStoryboard: .Main)
        
        
        let editVC = EditImageViewController.instantiate(fromAppStoryboard: .Main)
        
        CropUser.shared.editedImage = croppedImage
        CropUser.shared.image = croppedImage
        CropUser.shared.ratio = self.selectedType
        CropUser.shared.countryName = self.country
        self.navigationController?.pushViewController(editVC, animated: true)
    }

    func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CropViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
  
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

extension IGRPhotoTweakView {
    
    public override func awakeFromNib() {
        self.stopScroll()
    }
    func stopScroll(){
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 1.0
    }
    
}
