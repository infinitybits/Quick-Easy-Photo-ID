//
//  EditImageViewController.swift
//  Quick & Easy Photo ID
//
//  Created by Nirav Gondaliya on 15/05/18.
//  Copyright © 2018 Nirav Gondaliya. All rights reserved.
//

import UIKit
import Cmg
import Toast_Swift

enum FilterType {
    case Brightness
    case Contrast
    case Situration
}


class EditImageViewController: BaseViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var lblFiltrTitle: UILabel!
    
    var colorControl = ColorControls.init()
    var selectedFilterType:FilterType = .Brightness
    var isFromHome:Bool = false
    
    var tmpImage:UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackBtn(withSelector: #selector(goBack))

        if isFromHome {
            
        }else {
            let imgOriginal = CropUser.shared.image
            let img = imgOriginal?.imageWithBorder(width: 100, color: UIColor.white)
            self.imgView.image = img
            self.tmpImage = CropUser.shared.image
        }
        
        self.lblFiltrTitle.text = "Brightness"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "EDIT"
    }
    
    @IBAction func contrastChanged(_ sender: UISlider) {
        if self.selectedFilterType == .Brightness {
            self.colorControl.brightness = sender.value
        }else if self.selectedFilterType == .Contrast {
            self.colorControl.contrast = sender.value
        }else {
            self.colorControl.saturation = sender.value
        }
        let img = tmpImage.imageWithBorder(width: 100, color: UIColor.white)
        self.imgView.image = self.colorControl.processing(img!)
    }
    
    @IBAction func onBtnBrightnessClick(_ sender: UIButton) {
        self.lblFiltrTitle.text = "Brightness"
        self.selectedFilterType = .Brightness
        self.slider.maximumValue = 1
        self.slider.minimumValue = -1
        self.slider.value = 0
    }
    
    @IBAction func onBtnContrastClick(_ sender: UIButton) {
        self.lblFiltrTitle.text = "Contrast"
        self.selectedFilterType = .Contrast
        self.slider.maximumValue = 2
        self.slider.minimumValue = 0
        self.slider.value = 1
    }
    
    @IBAction func onBtnSaturationClick(_ sender: UIButton) {
        self.lblFiltrTitle.text = "Saturation"
        self.selectedFilterType = .Situration
        self.slider.maximumValue = 2
        self.slider.minimumValue = 0
        self.slider.value = 1
    }
    @IBAction func onBtnCameraClick(_ sender: UIButton) {
        let countryVC = CountryViewController.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(countryVC, animated: true)
    }
    
    @IBAction func onBtnContinueClick(_ sender: UIButton) {
        if isFromHome {
            self.displayAlert(message: "No image for print.")
        }else {
            self.gotoHome()
        }
    }
    
    @IBAction func onBtnSaveClick(_ sender: UIButton) {
        if isFromHome {
            self.displayAlert(message: "No image for save.")
        }else {
            self.saveImage(image: self.imgView.image!)
        }
    }
    
    @IBAction func onBtnCloseClick(_ sender: UIButton) {
        self.goBack()
    }
    
    @objc func gotoHome() {
        
        CropUser.shared.editedImage = self.imgView.image
        
        let homeVC = HomeViewController.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func saveImage(image:UIImage) {
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            self.view.makeToast("Image saved to photos.", duration: 3.0, position: .bottom)
            
        }
    }
    
    func displayAlert(message:String) {
        let alert = UIAlertController (title: "Alert", message: message, preferredStyle: .alert)
        let btnOK = UIAlertAction (title: "OK", style: .cancel, handler: nil)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIImage {
    func imageWithBorder(width: CGFloat, color: UIColor) -> UIImage? {
//        let square = CGSize(width: min(size.width, size.height) + width * 2, height: min(size.width, size.height) + width * 2)
        
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: self.size))
        imageView.contentMode = .center
        imageView.image = self
        imageView.layer.borderWidth = width
        imageView.layer.borderColor = UIColor.black.cgColor
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
//        let squares = CGSize(width: min(size.width, size.height) + width * 2 - 20, height: min(size.width, size.height) + width * 2 - 20)
         let imageViews = UIImageView(frame: CGRect(origin: CGPoint(x: 40, y: 40), size: self.size))
        imageViews.contentMode = .center
        imageViews.image = result
        imageViews.layer.borderWidth = 50
        imageViews.layer.borderColor = UIColor.white.cgColor
        
        UIGraphicsBeginImageContextWithOptions(imageViews.bounds.size, false, scale)
        guard let contexst = UIGraphicsGetCurrentContext() else { return nil }
        imageViews.layer.render(in: contexst)
        let result2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result2
    }
    
    func imageWithInnerBorder(width: CGFloat, color: UIColor) -> UIImage? {
//        let square = CGSize(width: min(size.width, size.height) + width * 2 - 20, height: min(size.width, size.height) + width * 2 - 20)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 10, y: 10), size: self.size))
        imageView.contentMode = .center
        imageView.image = self
        imageView.layer.borderWidth = width
        imageView.layer.borderColor = color.cgColor
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
