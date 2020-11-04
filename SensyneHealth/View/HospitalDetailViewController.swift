//
//  HospitalDetailViewController.swift
//  SensyneHealth
//
//  Created by Moban Michael on 03/11/2020.
//

import Foundation
import UIKit
import RxSwift

class HospitalDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var hospital:Hospital?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    //MARK: UI
    fileprivate func setUpUI(){
        if let currentHospital = hospital{
            self.title = currentHospital.OrganisationName
        }
    }
    
    //MARK: Action
    @IBAction func doneButtonTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

