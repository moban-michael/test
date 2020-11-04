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
    
    func getAllHospitalListOnline() -> Observable<[Hospital]> {
        
        return Observable<[Hospital]>.create { observer in
            
            var hospitals:[Hospital]?
            let url = URL(string: Constant.Service.url)
            
            do {
                let result = try String(contentsOf: url!, encoding: .macOSRoman)
                
                hospitals = []
                for i in 1..<result.rows.count {
                    let rowValue = result.rows[i].components(separatedBy:Constant.General.delimiter)
                    let hospital = Hospital.init(values: rowValue)
                    hospitals?.append(hospital)
                    
                    if hospitals!.count%100 == 0 {
                        observer.onNext(hospitals!)
                    }
                }
                observer.onNext(hospitals!)
            }
            catch {
                print(error)
                observer.onNext([])
            }
            return Disposables.create {
                
            }
        }
    }
}
