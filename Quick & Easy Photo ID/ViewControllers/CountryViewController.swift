//
//  CountryViewController.swift
//  Quick & Easy Photo ID
//
//  Created by Nirav Gondaliya on 05/05/18.
//  Copyright © 2018 Nirav Gondaliya. All rights reserved.
//

import UIKit

class CountryViewController: BaseViewController {

    @IBOutlet weak var countryTableView: UITableView!
    
    let countryList = ["America", "Bangladesh", "Canada", "China", "India", "Pakistan", "Schengen"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.countryTableView.register(UINib(nibName: "CountryIDCell", bundle: nil), forCellReuseIdentifier: "CountryIDCell")
        self.addNavBackBtn(withSelector: #selector(goBack))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let colors = [UIColor(red: 136.0/255.0, green: 1.0/255.0, blue: 13.0/255.0, alpha: 1.0),UIColor(red: 44.0/255.0, green: 50.0/255.0, blue: 67.0/255.0, alpha: 1.0)]
        self.navigationController?.navigationBar.setGradientBackground(colors: colors)
        navigationItem.title = "Country ID"
    }
}

extension CountryViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryIDCell") as! CountryIDCell
        
        cell.lblCountry.text = self.countryList[indexPath.row]
        cell.imgFlag.image = UIImage (named: String (format: "flag_%@", self.countryList[indexPath.row]))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let idTypeVC = IDTypeViewController.instantiate(fromAppStoryboard: .Main)
        
        if indexPath.row == 0 {
            idTypeVC.selectedCountry = Constants.countryAmerica
        }else if indexPath.row == 1 {
            idTypeVC.selectedCountry = Constants.countryBangladesh
        }else if indexPath.row == 2 {
            idTypeVC.selectedCountry = Constants.countryCanada
        }else if indexPath.row == 3 {
            idTypeVC.selectedCountry = Constants.countryChina
        }else if indexPath.row == 4 {
            idTypeVC.selectedCountry = Constants.countryIndia
        }else if indexPath.row == 5 {
            idTypeVC.selectedCountry = Constants.countryPakistan
        }else {
            idTypeVC.selectedCountry = Constants.countrySchengen
        }
        
        self.navigationController?.pushViewController(idTypeVC, animated: true)
    }
}




