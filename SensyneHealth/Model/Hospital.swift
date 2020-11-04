//
//  Hospital.swift
//  SensyneHealth
//
//  Created by Moban Michael on 03/11/2020.
//

import Foundation

struct Hospital: Codable, Equatable  {
    
    var OrganisationID      : String
    var OrganisationCode    : String
    var OrganisationType    : String
    var SubType             : String
    var Sector              : String
    var OrganisationStatus  : String
    var IsPimsManaged       : String
    var OrganisationName    : String
    var Address1            : String
    var Address2            : String
    var Address3            : String
    var City                : String
    var County              : String
    var Postcode            : String
    var Latitude            : String
    var Longitude           : String
    var ParentODSCode       : String
    var ParentName          : String
    var Phone               : String
    var Email               : String
    var Website             : String
    var Fax                 : String
    
    init(OrganisationID: String,OrganisationCode: String,OrganisationType:String , SubType: String = "", Sector: String = "",OrganisationStatus: String = "",OrganisationName: String,IsPimsManaged: String = "", Address1: String = "", Address2: String = "",Address3: String = "",City: String = "", County: String = "", Postcode: String = "",Latitude: String = "",Longitude: String = "", ParentODSCode: String = "", ParentName: String = "",Phone: String = "",Email: String = "", Website: String = "", Fax: String = "") {
        
        self.OrganisationID     = OrganisationID
        self.OrganisationCode   = OrganisationCode
        self.OrganisationType   = OrganisationType
        self.SubType            = SubType
        self.Sector             = Sector
        self.OrganisationStatus = OrganisationStatus
        self.OrganisationName   = OrganisationName
        self.IsPimsManaged      = IsPimsManaged
        self.Address1           = Address1
        self.Address2           = Address2
        self.Address3           = Address3
        self.City               = City
        self.County             = County
        self.Postcode           = Postcode
        self.Latitude           = Latitude
        self.Longitude          = Longitude
        self.ParentODSCode      = ParentODSCode
        self.ParentName         = ParentName
        self.Phone              = Phone
        self.Email              = Email
        self.Website            = Website
        self.Fax                = Fax
    }
    
    init(values: [String]) {
        
        self.OrganisationID     = values[0]
        self.OrganisationCode   = values[1]
        self.OrganisationType   = values[2]
        self.SubType            = values[3]
        self.Sector             = values[4]
        self.OrganisationStatus = values[5]
        self.IsPimsManaged      = values[6]
        self.OrganisationName   = values[7]
        self.Address1           = values[8]
        self.Address2           = values[9]
        self.Address3           = values[10]
        self.City               = values[11]
        self.County             = values[12]
        self.Postcode           = values[13]
        self.Latitude           = values[14]
        self.Longitude          = values[15]
        self.ParentODSCode      = values[16]
        self.ParentName         = values[17]
        self.Phone              = values[18]
        self.Email              = values[19]
        self.Website            = values[20]
        self.Fax                = values[21]
    }
    
    static func ==(lhs: Hospital, rhs: Hospital) -> Bool {
        return lhs.OrganisationID == rhs.OrganisationID
    }
}
