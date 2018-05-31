//
//  AccuracyViewController.swift
//  Quick & Easy Photo ID
//
//  Created by bhavin on 23/05/18.
//  Copyright © 2018 Nirav Gondaliya. All rights reserved.
//

import UIKit
import IGRPhotoTweaks

import AVFoundation

class AccuracyViewController: IGRPhotoTweakViewController , UIScrollViewDelegate{

    //MARK: -IBOutlets
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var imgMask: UIImageView!
    @IBOutlet var leftSizeLabel: UILabel!
    @IBOutlet var rightSideLabel: UILabel!
    @IBOutlet var bottomSideLabel: UILabel!
    @IBOutlet weak var btnPhotoType : UIButton!
    @IBOutlet var cropAreaView: CropAreaView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var leadingC: NSLayoutConstraint!
    @IBOutlet var trailingC: NSLayoutConstraint!
    @IBOutlet weak var btnMenu : UIBarButtonItem!
    
    @IBOutlet var ubeView: UIView!
    
    //MARK: - class variable
    
    var croppedImage : UIImage?
    var selectedRatio:String?
    var country:String?
    var selectedType:String?
     var hamburgerMenuIsVisible = false
    
    
  

    
    //MARK: - custom methods
    
    func setupView(){
        
        
        self.resetView()
        self.setupThemes()
        
        self.delegate = self
        self.setCropAspectRect(aspect: CropUser.shared.ratio)
        self.lockAspectRatio(true)
        
        //imgMask.ratio
        IGRCropCornerLine.appearance().backgroundColor = UIColor.clear
        IGRCropLine.appearance().backgroundColor = UIColor.clear
        IGRCropGridLine.appearance().backgroundColor = UIColor.clear
        IGRCropCornerLine.appearance().backgroundColor = UIColor.clear
        IGRCropMaskView.appearance().backgroundColor = UIColor.clear

        
         self.addNavBackBtn(withSelector: #selector(goBack))
        

        
        if let country = country{
            self.btnPhotoType.setTitle(country, for: .normal)
        }
        
        self.leftSizeLabel.text = selectedType ?? ""
        self.rightSideLabel.text = selectedType ?? ""
        self.bottomSideLabel.text = selectedType ?? ""
        
        let oldLeftFrame = leftSizeLabel.frame
        let oldRightFrame = rightSideLabel.frame
        
        leftSizeLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        rightSideLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        leftSizeLabel.frame = CGRect(x: 0, y: oldLeftFrame.origin.y, width: oldLeftFrame.size.width, height: oldLeftFrame.size.height)
      
        
        
        DispatchQueue.main.async {
            self.mainView.layer.cornerRadius = 8
            
        }
        
    }
    
    func addNavBackBtn(withSelector selector:Selector){
        
        let btn = UIButton (frame: CGRect (x: 0, y: 0, width: 35, height: 35))
        btn.setImage(#imageLiteral(resourceName: "img_Back"), for: .normal)
        btn.addTarget(self, action: selector, for: .touchUpInside)
        let barBtn = UIBarButtonItem (customView: btn)
        
        self.navigationItem.leftBarButtonItems = [barBtn]
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
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
    
    //MARK: - scrollview delegate

    
    //MARK: - Action Methid
    
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
    
    @IBAction func btnPhoyoTypeTapped(_ sender: UIButton) {
    }
    @IBAction func btnAcceptedTapped(_ sender: UIButton) {
        

       
        self.cropAction()
    }
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.leadingC.constant = self.view.frame.size.width
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        self.view.bringSubview(toFront: self.ubeView)
    }
    
}

extension AccuracyViewController : IGRPhotoTweakViewControllerDelegate {
    func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage) {
        
        CropUser.shared.image = croppedImage
        
//        let accuracyVC = AccuracyViewController.instantiate(fromAppStoryboard: .Main)
//        accuracyVC.croppedImage = croppedImage
//        accuracyVC.country = self.country
//        accuracyVC.selectedType = self.selectedType
//        self.navigationController?.pushViewController(accuracyVC, animated: true)
        
        let editVC = EditImageViewController.instantiate(fromAppStoryboard: .Main)
        
        CropUser.shared.editedImage = croppedImage
        CropUser.shared.image = croppedImage
        CropUser.shared.ratio = self.selectedRatio
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController) {
        self.navigationController?.popViewController(animated: true)
    }
}
