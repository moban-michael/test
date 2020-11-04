//
//  HospitalListViewController.swift
//  SensyneHealth
//
//  Created by Moban Michael on 03/11/2020.
//

import UIKit
import RxSwift

class HospitalListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var hospitals       = [Hospital]()
    fileprivate var filteredList    = [Hospital]()
    fileprivate var filterring      = false
    private let disposeBag          = DisposeBag()
    let hospitalListViewModal       = HospitalListViewModel()
    var selectedHospital            : Hospital?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUI()
        loadData()
    }
    
    //MARK: UI
    
    fileprivate func setUpUI(){
        title = "Hospitals"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
    }
    
    //MARK: Loading Data
    fileprivate func loadData(){
        //self.showProgress() // uncomment this if required a progress view to indicate user
        hospitalListViewModal.hospitallist.asObservable().subscribe { (event) in
            if let hospitalList = event.element{
                //self.hospitals.removeAll()
                self.hospitals.append(contentsOf: hospitalList)
                onMainQueue {
                    self.tableView.reloadData()
                    //self.hideProgress()
                }
            }
        }.disposed(by: self.disposeBag)
        
        DispatchQueue.global(qos: .background).async {
            self.hospitalListViewModal.getHospitalList()
        }
        
    }
}

private typealias prepareForSegue = HospitalListViewController
extension prepareForSegue{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Load Detail") {
            if let detailViewController = segue.destination as? HospitalDetailViewController {
                detailViewController.hospital = self.selectedHospital
            }
        }
    }
}

private typealias TableViewDataSource = HospitalListViewController
extension TableViewDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterring ? self.filteredList.count : hospitals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell Identifier", for: indexPath)
        cell.textLabel?.text = self.filterring ? self.filteredList[indexPath.row].OrganisationName : self.hospitals[indexPath.row].OrganisationName
        cell.tag = indexPath.row
        return cell
    }
}

private typealias TableViewDelegate = HospitalListViewController
extension TableViewDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedHospital = hospitals[indexPath.row]
        let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))
        performSegue(withIdentifier: "Load Detail", sender: cell)
    }
}

private typealias SearchResultsDelegate = HospitalListViewController
extension SearchResultsDelegate: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            self.filteredList = self.hospitals.filter({ (hospital) -> Bool in
                return hospital.OrganisationName.lowercased().contains(text.lowercased())
            })
            self.filterring = true
        }
        else {
            self.filterring = false
            self.filteredList = [Hospital]()
        }
        self.tableView.reloadData()
    }
}

