//
//  FilterPopUpViewController.swift
//  SensyneHealth
//
//  Created by Moban Michael on 04/11/2020.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class FilterPopUpViewController: UIViewController {
    
    @IBOutlet weak var detailTableView: UITableView!
    var selectedFilter                  = PublishRelay<(FilterCategory, String)>()
    var category: FilterCategory        = .None
    var hospitals : ([Hospital],Hospital)?
    fileprivate var filterList          = [String]()
    fileprivate var filterDetailList    = [String]()
    let filterPopupViewModal            = FilterPopupVieewModal()
    var isDetaiViewPresent: Bool        = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    //MARK: UI
    fileprivate func setUpUI(){
        filterList = filterPopupViewModal.getFilterCategory()
    }
}

private typealias TableViewDataSource = FilterPopUpViewController
extension TableViewDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isDetaiViewPresent ? filterDetailList.count : filterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell Identifier", for: indexPath)
        cell.textLabel?.text = isDetaiViewPresent ? filterDetailList[indexPath.row] : filterList[indexPath.row]
        return cell
    }
}

private typealias TableViewDelegate = FilterPopUpViewController
extension TableViewDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isDetaiViewPresent {
            self.selectedFilter.accept((category,filterDetailList[indexPath.row]))
            self.dismiss(animated: true, completion: nil)
        }else{
            category = FilterCategory.init(rawValue: filterList[indexPath.row])!
            if category == .None {
                self.selectedFilter.accept((category,""))
                self.dismiss(animated: true, completion: nil)
            }else{
                filterDetailList = filterPopupViewModal.getFilterDetailList(category, hospitals: hospitals!).uniques
                isDetaiViewPresent = true
                UIView.transition(with: tableView, duration: 1.0, options: .transitionCurlDown, animations: {self.detailTableView.reloadData()}, completion: nil)
            }
        }
    }
}
