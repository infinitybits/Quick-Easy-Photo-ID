//
//  HomeViewController.swift
//  Quick & Easy Photo ID
//
//  Created by Nirav Gondaliya on 09/05/18.
//  Copyright © 2018 Nirav Gondaliya. All rights reserved.
//

import UIKit
import IGRPhotoTweaks
import Toast_Swift

class HomeViewController: BaseViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAddress: UITextView!
    @IBOutlet weak var imgUser: UIImageView!
    var img:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackBtn(withSelector: #selector(goBack))
       // self.addRightBtnAdd(withSelector: #selector(save))
        
        self.imgUser.image = CropUser.shared.editedImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Print"
    }

    @IBAction func onBtnSaveClick(_ sender: UIButton) {
        self.saveImage(image: self.imgUser.image!)
    }
    
    @objc func save() {
        let imageNames = self.loadImagesFromAlbum()
        if imageNames.count >= 5 {
            self.alert(message: kAddImage) {}
        } else {
            let name = imageNames.count == 0 ? "1" : String(imageNames.count + 1)
            self.saveImageToDirectory(image: self.imgUser.image!, imageName: name) {
                self.alert(message: kImageSave, completion: { [weak self] in
                    self?.backNav()
                })
            }
        }
    }
    
    func backNav() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 5], animated: true)
    }
    
    @IBAction func onBtnNextClick(_ sender: UIButton) {
        
        if (self.txtEmail.text?.isEmpty)! {
            let alert = UIAlertController (title: "Required", message: "Please add Email.", preferredStyle: .alert)
            let btnOK = UIAlertAction (title: "OK", style: .cancel, handler: nil)
            alert.addAction(btnOK)
            self.present(alert, animated: true, completion: nil)
        }else {
            let checkOutVC = CheckOutViewController.instantiate(fromAppStoryboard: .Main)
            self.navigationController?.pushViewController(checkOutVC, animated: true)
        }
    }
}

extension HomeViewController {
    
   @objc func saveImage(image:UIImage) {
    
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
    
    @objc func addRightBtnAdd(withSelector selector:Selector){
        let btn = UIButton (frame: CGRect (x: 0, y: 0, width: 35, height: 35))
        btn.setTitle("Add", for: .normal)
        btn.addTarget(self, action: selector, for: .touchUpInside)
        let barBtn = UIBarButtonItem (customView: btn)
        
        self.navigationItem.rightBarButtonItems = [barBtn]
    }
  
}

