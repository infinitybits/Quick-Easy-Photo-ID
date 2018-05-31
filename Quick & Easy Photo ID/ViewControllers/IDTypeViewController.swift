//
//  IDTypeViewController.swift
//  Quick & Easy Photo ID
//
//  Created by Nirav Gondaliya on 06/05/18.
//  Copyright © 2018 Nirav Gondaliya. All rights reserved.
//

import UIKit
import IGRPhotoTweaks

class IDTypeViewController: BaseViewController {

    @IBOutlet weak var idTypeTableView: UITableView!
    var picker:UIImagePickerController?=UIImagePickerController()
    
    var IDTypeList = [String]()
    var IDTypeSizeList = [String]()
    var IDTypeAspectRatioList = [String]()
    var selectedCountry:String?
    var selectedAspectRatio:String = "35:45"
    var selectedSize:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackBtn(withSelector: #selector(goBack))
        picker?.delegate = self
        self.idTypeTableView.register(UINib(nibName: "CountryIDCell", bundle: nil), forCellReuseIdentifier: "CountryIDCell")
        self.idTypeTableView.register(UINib(nibName: "IDTypeCell", bundle: nil), forCellReuseIdentifier: "IDTypeCell")
        
        picker?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "ID Type"
        
        if selectedCountry == Constants.countryAmerica {
            self.IDTypeList = Constants.americanList
            self.IDTypeSizeList = Constants.americanSizeList
            self.IDTypeAspectRatioList = Constants.americanAspectRatioList
            
        }else if selectedCountry == Constants.countryBangladesh {
            self.IDTypeList = Constants.bangladeshList
            self.IDTypeSizeList = Constants.bangladeshSizeList
            self.IDTypeAspectRatioList = Constants.bangladeshAspectRatioList
            
        }else if selectedCountry == Constants.countryCanada {
            self.IDTypeList = Constants.canadaList
            self.IDTypeSizeList = Constants.canadaSizeList
            self.IDTypeAspectRatioList = Constants.canadaAspectRatioList
            
        }else if selectedCountry == Constants.countryChina {
            self.IDTypeList = Constants.chinaList
            self.IDTypeSizeList = Constants.chinaSizeList
            self.IDTypeAspectRatioList = Constants.chinaAspectRatioList
            
        }else if selectedCountry == Constants.countryIndia {
            self.IDTypeList = Constants.indianList
            self.IDTypeSizeList = Constants.indianSizeList
            self.IDTypeAspectRatioList = Constants.indianAspectRatioList
            
        }else if selectedCountry == Constants.countryPakistan {
            self.IDTypeList = Constants.pakistanList
            self.IDTypeSizeList = Constants.pakistanSizeList
            self.IDTypeAspectRatioList = Constants.pakistanAspectRatioList
            
        }else if selectedCountry == Constants.countrySchengen {
            self.IDTypeList = Constants.schengenList
            self.IDTypeSizeList = Constants.schengenSizeList
            self.IDTypeAspectRatioList = Constants.schengenAspectRatioList
            
        }
        
    }
   
}

extension IDTypeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.IDTypeList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryIDCell") as! CountryIDCell
            cell.imgArrow.image = #imageLiteral(resourceName: "img_Down")
            cell.imgFlag.image = UIImage (named: String (format: "flag_%@", self.selectedCountry!))
            cell.lblCountry.text = self.selectedCountry!
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IDTypeCell") as! IDTypeCell
            cell.lblTitle.text = self.IDTypeList[indexPath.row - 1]
            cell.lblDescription.text = self.IDTypeSizeList[indexPath.row - 1]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            CropUser.shared.ratio = self.IDTypeAspectRatioList[indexPath.row - 1]
            self.selectedSize = self.IDTypeList[indexPath.row - 1] + " " + self.IDTypeSizeList[indexPath.row - 1]
            DispatchQueue.main.async {
//                self.showOptionForImage()
                
               
                let cropVC = TakePhotoViewController.instantiate(fromAppStoryboard: .Main)
                //        cropVC.image = image
                cropVC.selectedRatio = CropUser.shared.ratio
                cropVC.country = self.selectedCountry
                cropVC.selectedType = self.selectedSize
                self.navigationController?.pushViewController(cropVC, animated: true)
                
            }
        }
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

extension IDTypeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
        
        CropUser.shared.image = image
        let cropVC = TakePhotoViewController.instantiate(fromAppStoryboard: .Main)
//        cropVC.image = image
        cropVC.country = self.selectedCountry
        cropVC.selectedType = self.selectedSize
        
//        let cropVC = TakePhotoViewController.instantiate(fromAppStoryboard: .Main)
//        cropVC.tmpSelectedImage = image
//        cropVC.country = self.selectedCountry
//        cropVC.selectedType = self.selectedSize
        
        picker.dismiss(animated: true) {
//            self.navigationController?.pushViewController(cropVC, animated: true)
        }
    }
}



