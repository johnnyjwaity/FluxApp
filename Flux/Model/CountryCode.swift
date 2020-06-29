//
//  CountryCode.swift
//  Flux
//
//  Created by Johnny Waity on 5/13/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import Foundation

class CountryCode {
    let code:String
    let name:String
    let abreviation:String
    
    static var codes:[CountryCode] = []
    static var unitedStates:CountryCode!
    
    static func loadCodes() {
        var tempCodes:[CountryCode] = []
        let file = "extensions"
        if let path = Bundle.main.path(forResource: file, ofType: "csv"){
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let lines = data.components(separatedBy: .newlines)
                for l in lines {
                    if l.count > 0 {
                        let parts = l.components(separatedBy: ",")
                        var c = parts[2]
                        if c.contains("-") {
                            c = c.components(separatedBy: "-")[0]
                        }
                        
                        let newCountryCode = CountryCode(code: c, name: parts[0], abreviation: parts[1])
                        if parts[1] == "USA" {
                            CountryCode.unitedStates = newCountryCode
                        }
                        tempCodes.append(newCountryCode)
                    }
                }
                codes = tempCodes.sorted(by: {$0.name < $1.name})
            } catch {
                print(error)
            }
        }
    }
    
    
    init(code:String, name:String, abreviation:String){
        self.code = code
        self.name = name
        self.abreviation = abreviation
    }
}
