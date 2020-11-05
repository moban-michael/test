//
//  HospitalListViewControllerTest.swift
//  SensyneHealthTests
//
//  Created by Moban Michael on 05/11/2020.
//

import XCTest
import RxSwift

@testable import SensyneHealth

class HospitalListViewControllerTest: XCTestCase {
    
    var controller  : HospitalListViewController!
    var tableView   : UITableView!
    var dataSource  : UITableViewDataSource!
    var delegate    : UITableViewDelegate!
    
    var pageNumber          = 1
    var viewModal           = HospitalListViewModel()
    private let disposeBag  = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(withIdentifier: "MainView") as? HospitalListViewController
        controller.loadViewIfNeeded()
        
        guard let tableview = controller.tableView else {
            return XCTFail("Controller's should have a table view")
        }
        tableView = tableview
        delegate = tableView.delegate
        dataSource = tableView.dataSource
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    /* Testing the tableview custom cell*/
    func testTableViewHasCells() {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell Identifier")
        
        XCTAssertNotNil(cell,
                        "TableView should be able to dequeue cell with identifier: 'Cell Identifier'")
    }
    
    /* Testing the delegate and data source methods*/
    func testTableViewDelegateDatasourceIsViewController() {
        XCTAssertTrue(tableView.delegate === controller,
                      "Controller should be delegate for the table view")
        XCTAssertTrue(tableView.dataSource === controller,
                      "Controller should be delegate for the table view")
    }
    
    func testThatViewLoads(){
        XCTAssertNotNil(self.controller.view, "View not initiated properly");
    }
    
    func testHasTitleViewNamedHospitals() {
        
        let title = controller.navigationItem.title
        XCTAssertEqual(title, "Hospitals")
    }
    
    func testHasRightBarButtonItem() {
        
        XCTAssertNotNil(self.controller.navigationItem.rightBarButtonItem)
    }
    
    func testHasRightBarButtonItemTargetCorrectlyAssigned() {
        
        if let rightBarButtonItem = self.controller.navigationItem.rightBarButtonItem {
            
            XCTAssertNotNil(rightBarButtonItem.target)
            XCTAssert(rightBarButtonItem.target === self.controller)
        }
        else {
            
            XCTAssertTrue(false)
        }
    }
    
    func testHasRightBarButtonItemActionMethodCorrectlyAssigned() {
        
        if let rightBarButtonItem = self.controller.navigationItem.rightBarButtonItem {
            
            XCTAssertTrue(rightBarButtonItem.action!.description == "filterTappedWithSender:")
        }
        else {
            
            XCTAssertTrue(false)
        }
    }
    
    func testloadData() {
        weak var exception = expectation(description: "Wait for call completion")
        
        controller.hospitalListViewModal.hospitalList.asObservable().subscribe { (event) in
            if let hospitals = event.element{
                XCTAssertTrue(hospitals.1.OrganisationStatus == FilterCategory.OrganisationStatus.rawValue)
                exception?.fulfill()
            }
        }.disposed(by: self.disposeBag)
        controller.loadData()

        waitForExpectations(timeout: 60) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                XCTFail()
            }
        }
    }
}
