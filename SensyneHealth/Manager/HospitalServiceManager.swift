//
//  HospitalServiceManager.swift
//  SensyneHealth
//
//  Created by Moban Michael on 04/11/2020.
//

import Foundation
import RxCocoa
import RxSwift

class HospitalServiceManager {
    
    func getAllHospitalListOnline() -> Observable<([Hospital],Hospital)> {
        
        return Observable<([Hospital],Hospital)>.create { observer in
            
            var hospitals:[Hospital]?
            let url = URL(string: Constant.Service.url)
            
            do {
                let result = try String(contentsOf: url!, encoding: .macOSRoman)
                
                hospitals = []
                var header:Hospital?
                
                for i in 0..<result.rows.count {
                    let rowValue = result.rows[i].components(separatedBy:Constant.General.delimiter)
                    let hospital = Hospital.init(values: rowValue)
                    if i == 0{//header
                        header = hospital
                    }else{
                        
                        hospitals?.append(hospital)
                    }
                    if hospitals!.count > 0, hospitals!.count%100 == 0 {
                        observer.onNext((hospitals!, header!))
                    }
                }
                observer.onNext((hospitals!, header!))
            }
            catch {
                print(error)
                observer.onNext(([], Hospital.init(OrganisationID: "", OrganisationCode: "", OrganisationType: "", OrganisationName: "")))
            }
            return Disposables.create {
                
            }
        }
    }
}
