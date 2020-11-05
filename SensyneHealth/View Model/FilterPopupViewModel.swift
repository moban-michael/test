//
//  FilterPopupViewModel.swift
//  SensyneHealth
//
//  Created by Moban Michael on 04/11/2020.
//

import Foundation

enum FilterCategory :String, CaseIterable {
    case OrganisationType   = "OrganisationType"
    case SubType            = "SubType"
    case OrganisationStatus = "OrganisationStatus"
    case IsPimsManage       = "IsPimsManaged"
    case None               = "Clear Filter"
    
    func getCategoryDetails(hospitals:[Hospital]) -> [String] {
        switch self {
        case .OrganisationType:
            return hospitals.compactMap({$0.OrganisationType})
        case .SubType:
            return hospitals.compactMap({$0.SubType})
        case .OrganisationStatus:
            return hospitals.compactMap({$0.OrganisationStatus})
        case .IsPimsManage:
            return hospitals.compactMap({$0.IsPimsManaged})
        case .None:
            return []
        }
    }
    
    func getFilteredList(hospitals:[Hospital], filter:String) -> [Hospital] {
        switch self {
        case .OrganisationType:
            return hospitals.filter({$0.OrganisationType == filter})
        case .SubType:
            return hospitals.filter({$0.SubType == filter})
        case .OrganisationStatus:
            return hospitals.filter({$0.OrganisationStatus == filter})
        case .IsPimsManage:
            return hospitals.filter({$0.IsPimsManaged == filter})
        case .None:
            return []
        }
    }
}

class FilterPopupVieewModal {
    
    func getFilterCategory() -> [String]  {
        
        return FilterCategory.allCases.map { ($0.rawValue) }
    }
    
    func getFilterDetailList(_ category: FilterCategory, hospitals:([Hospital],Hospital)) -> [String]  {
        
        return category.getCategoryDetails(hospitals: hospitals.0)
    }
}
