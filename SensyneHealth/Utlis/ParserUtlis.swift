//
//  ParserUtlis.swift
//  SensyneHealth
//
//  Created by Moban Michael on 04/11/2020.
//

import Foundation

class ParserUtlis {
    
    static func parseFileContent(_ filedata: String, delimiter: String = Constant.General.delimiter) -> [Hospital]{
        var hospitals:[Hospital] = []
        for i in 1..<filedata.rows.count {
            let rowValue = filedata.rows[i].components(separatedBy:delimiter)
            let hospital = Hospital.init(values: rowValue)
            hospitals.append(hospital)
        }
        return hospitals
    }
}
