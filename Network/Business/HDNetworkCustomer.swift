//
//  HDNetworkCustomer.swift
//  NetworkClient
//
//  Created by HanDong Wang on 2018/6/15.
//  Copyright © 2018年 HanDong Wang. All rights reserved.
//

import UIKit

let localServerBaseUrl = "http://10.33.70.34:8181"

protocol HDNetworkCustomer: HDNetworkResultType {
    
}

extension HDNetworkCustomer {
    var baseURL: String {
        return localServerBaseUrl
    }
    // 基本上保持不变就可以了
    var headers: [String : String] {
        return ["Content-Type": "application/json"]
    }
    
    func sendRequest(_ success: @escaping (Self.ResultType) -> Void, failure: @escaping (String) -> Void) {
        request(self, success, failure: failure)
    }
}
