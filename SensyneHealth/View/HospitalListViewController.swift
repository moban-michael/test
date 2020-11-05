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
    fileprivate var listAndHeader   : ([Hospital],Hospital)?
    fileprivate var filteredList    = [Hospital]()
    fileprivate var isFilterring    = false
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
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.filterTapped))
        rightBarButtonItem.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = rightBarButtonItem
        //UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "OpenSans", size: 14)! ], for: .normal)
    }
    
    //MARK: Loading Data
    func loadData(){
        //self.showProgress() // uncomment this if required a progress view to indicate user
        hospitalListViewModal.hospitalList.asObservable().subscribe { (event) in
            if let hospitalList = event.element{
                self.hospitals.removeAll()
                self.hospitals.append(contentsOf: hospitalList.0)
                self.listAndHeader = hospitalList
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
        return self.isFilterring ? self.filteredList.count : hospitals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell Identifier", for: indexPath)
        cell.textLabel?.text = self.isFilterring ? self.filteredList[indexPath.row].OrganisationName : self.hospitals[indexPath.row].OrganisationName
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
            self.isFilterring = true
        }
        else {
            self.isFilterring = false
            self.filteredList = [Hospital]()
        }
        self.tableView.reloadData()
    }
}

private typealias Filter = HospitalListViewController
extension Filter {
    
    @objc func filterTapped(sender: UIBarButtonItem){
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopupView") as! FilterPopUpViewController
        vc.hospitals = listAndHeader
        vc.selectedFilter.asObservable().subscribe { (event) in
            if let selectedFilter = event.element{
                if selectedFilter.0 == FilterCategory.None{
                    self.isFilterring = false
                    self.filteredList = [Hospital]()
                }else{
                    self.filteredList.removeAll()
                    self.isFilterring = true
                    self.filteredList = self.hospitalListViewModal.getFilteredHospitalList(hospitals: self.hospitals, selectedFilter: selectedFilter)
                }
                self.tableView.reloadData()
            }
        }.disposed(by: self.disposeBag)
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.barButtonItem = sender
        popover.delegate = self
        present(vc, animated: true, completion:nil)
    }
}

private typealias PopoverDelegate = HospitalListViewController
extension PopoverDelegate: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle{
        return .none
    }
}

