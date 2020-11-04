//
//  StringExtension.swift
//  SensyneHealth
//
//  Created by Moban Michael on 04/11/2020.
//

import Foundation

extension StringProtocol {
    
    var rows: [String] {
            var result: [String] = []
            enumerateLines { line, _ in result.append(line) }
            return result
        }
}
