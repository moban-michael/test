//
//  HospitalDataManager.swift
//  SensyneHealth
//
//  Created by Moban Michael on 03/11/2020.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

class HospitalDataManager {
    
    private let disposeBag  = DisposeBag()

    // Here we decide if it needs to do offline or online call
    func getAllHospitalList() -> Observable<([Hospital],Hospital)> {
        let hospitalServiceManager: HospitalServiceManager  = HospitalServiceManager()

        return Observable<([Hospital],Hospital)>.create { observer in
            
            if (NetworkReachabilityManager()?.isReachable)!{
                
                _ = hospitalServiceManager.getAllHospitalListOnline().subscribe(onNext: { (hospitalList) in
                    if hospitalList.0.count <= 0 { //Error
                        self.readFromCSV().subscribe(onNext: { (hospitalList) in
                            observer.onNext(hospitalList)
                        }).disposed(by: self.disposeBag)
                    }else{
                        observer.onNext(hospitalList)
                    }
                }, onError: { (error) in
                    print(error)
                    self.readFromCSV().subscribe(onNext: { (hospitalList) in
                        observer.onNext(hospitalList)
                    }).disposed(by: self.disposeBag)
                }, onCompleted: {
                    print("Completed")
                }, onDisposed: {
                    print("Disposed")
                })
                
            }else{
                self.readFromCSV().subscribe(onNext: { (hospitalList) in
                    observer.onNext(hospitalList)
                }).disposed(by: self.disposeBag)
            }
            return Disposables.create {
            }
        }
    }
    
    func readFromCSV() -> Observable<([Hospital],Hospital)>{
        return Observable<([Hospital],Hospital)>.create { observer in
            guard let filepath = Bundle.main.path(forResource: Constant.General.fileName, ofType: Constant.General.fileType)
            else {
                print("File Path Error")
                observer.onNext(([], Hospital.init(OrganisationID: "", OrganisationCode: "", OrganisationType: "", OrganisationName: "")))
                return [] as! Disposable
            }
            do {
                let result = try String(contentsOfFile: filepath, encoding: .macOSRoman)
                var hospitals:[Hospital] = []
                var header:Hospital?

                for i in 0..<result.rows.count {
                    let rowValue = result.rows[i].components(separatedBy:Constant.General.fileDelimiter)
                    let hospital = Hospital.init(values: rowValue)
                    if i == 0{//header
                        header = hospital
                    }else{
                        
                        hospitals.append(hospital)
                    }
                    
                    if hospitals.count%100 == 0 { // reloading table view for every 100 items
                        observer.onNext((hospitals,header!))
                    }
                }
                observer.onNext((hospitals,header!))
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
