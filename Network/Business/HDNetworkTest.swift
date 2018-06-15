//
//  HDNetworkTest.swift
//  NetworkClient
//
//  Created by HanDong Wang on 2018/6/15.
//  Copyright © 2018年 HanDong Wang. All rights reserved.
//

import UIKit

fileprivate let testPath = "/upload"

struct HDTestResult: Codable {
    let a: String?
    let b: String?
}

extension HDNetwork {
    struct test: HDNetworkCustomer {
        typealias ResultType = HDTestResult
        
        let userName: String
        let userPassword: String
        
        init(userName: String, password: String) {
            self.userName = userName
            self.userPassword = password
        }
        
        var path: String { return testPath }
        var method: HTTPMethod { return .post }
        var parameters: Parameters {
            return ["userName":  self.userName, "password": self.userPassword]
        }
    }
}
