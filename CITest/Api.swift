//
//  MoyaServise.swift
//  CITest
//
//  Created by Admin on 6/17/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import Moya

enum Api {
    case getList
}

extension Api: TargetType {
    var baseURL: URL {
        return URL(string:  "https://api.openbrewerydb.org/")!
    }
    
    var path: String {
        return "breweries"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data(count: 1)
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
       return nil
    }
    
    
}
