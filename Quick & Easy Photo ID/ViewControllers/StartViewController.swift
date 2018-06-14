//
//  StartViewController.swift
//  Quick & Easy Photo ID
//
//  Created by Nirav Gondaliya on 05/05/18.
//  Copyright © 2018 Nirav Gondaliya. All rights reserved.
//

import UIKit

class StartViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onBtnStartClick(_ sender: UIButton) {
        //        let mainVC = MaiinViewController.instantiate(fromAppStoryboard: .Main)
        //        self.navigationController?.pushViewController(mainVC, animated: true)
        
        //change navigation 06.06.2018
        
        let termsVC = TermsViewController.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(termsVC, animated: true)
        
    }
}
