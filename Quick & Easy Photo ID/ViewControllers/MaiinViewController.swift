//
//  MaiinViewController.swift
//  Quick & Easy Photo ID
//
//  Created by Nirav Gondaliya on 19/05/18.
//  Copyright © 2018 Nirav Gondaliya. All rights reserved.
//

import UIKit

class MaiinViewController: BaseViewController {

    var picker:UIImagePickerController?=UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackBtn(withSelector: #selector(goBack))
        //self.addNavRightBtn(withSelector: #selector(btnMenu))
        picker?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let colors = [UIColor(red: 136.0/255.0, green: 1.0/255.0, blue: 13.0/255.0, alpha: 1.0),UIColor(red: 44.0/255.0, green: 50.0/255.0, blue: 67.0/255.0, alpha: 1.0)]
        self.navigationController?.navigationBar.setGradientBackground(colors: colors)
        navigationItem.title = "HOME"
        
        
    }

    @IBAction func onBtnCountryClick(_ sender: Any) {
        let countryVC = CountryViewController.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(countryVC, animated: true)
        
    }
    
    @IBAction func onBtnGallaryClick(_ sender: Any) {
        self.openLibrary()
    }
    
    @IBAction func onBtnEditClick(_ sender: UIButton) {
        let editVC = EditImageViewController.instantiate(fromAppStoryboard: .Main)
        editVC.isFromHome = true
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @IBAction func onBtnPhotoIDClick(_ sender: UIButton) {
        let countryVC = CountryViewController.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(countryVC, animated: true)
    }
    
    @objc func btnMenu() {
       
    }
    
    func addNavRightBtn(withSelector selector:Selector){
        
        let btn = UIButton (frame: CGRect (x: 0, y: 0, width: 35, height: 35))
        btn.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        btn.addTarget(self, action: selector, for: .touchUpInside)
        let barBtn = UIBarButtonItem (customView: btn)
        
        self.navigationItem.rightBarButtonItems = [barBtn]
    }
}

extension MaiinViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
       
//        let cropVC = CropViewController.instantiate(fromAppStoryboard: .Main)
//        cropVC.image = image
//        cropVC.country = Constants.countrySchengen
//        cropVC.selectedType = Constants.schengenList[0]
        
        
        //client chaage navigation
         CropUser.shared.ratio = Constants.schengenAspectRatioList[0]
        CropUser.shared.image = image
    
        let countryVC = CountryViewController.instantiate(fromAppStoryboard: .Main)
        countryVC.isNavigateToAccuracy = true
       
      
        
//            let cropVC = TakePhotoViewController.instantiate(fromAppStoryboard: .Main)
//            cropVC.tmpSelectedImage = image
//            cropVC.country = Constants.countrySchengen
//            cropVC.selectedType = Constants.schengenList[0]

        picker.dismiss(animated: true) {
            self.navigationController?.pushViewController(countryVC, animated: true)
        }
        
        
        picker.dismiss(animated: true) {
        }
    }
}

