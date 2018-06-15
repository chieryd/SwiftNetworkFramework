//
//  HDNetworkAPI.swift
//  NetworkClient
//
//  Created by HanDong Wang on 2018/6/15.
//  Copyright © 2018年 HanDong Wang. All rights reserved.
//

import UIKit

protocol HDNetworkAPI {
    var baseURL: String { get }
    var path: String { get }
    var url: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
    var encoding: ParameterEncoding { get }
    var task: HTTPTask { get }
    var headers: [String : String] { get }
}


extension HDNetworkAPI {
    var url: String { return baseURL + path }
    var parameters: Parameters { return Parameters() }
    var encoding: ParameterEncoding { return .jsonEncoding }
    var task: HTTPTask { return .request }
    var headers: [String : String] { return [:] }
}
