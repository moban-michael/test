//
//  HospitalListViewModel.swift
//  SensyneHealth
//
//  Created by Moban Michael on 03/11/2020.
//

import Foundation
import RxCocoa
import RxSwift

class HospitalListViewModel {
    
    let hospitalDataManager: HospitalDataManager  = HospitalDataManager()
    var hospitallist        = PublishRelay<([Hospital])>()
    private let disposeBag  = DisposeBag()
    
    
    func getHospitalList() {
        
        hospitalDataManager.getAllHospitalList().subscribe { (event) in
            
            if let hospitals = event.element {
                
                let sortedList = hospitals.sorted {
                    $0.OrganisationName < $1.OrganisationName
                }
                self.hospitallist.accept(sortedList)
            }
        }.disposed(by: self.disposeBag)
    }
}
