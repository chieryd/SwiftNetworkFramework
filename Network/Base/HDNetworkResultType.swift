//
//  HDNetworkResultType.swift
//  NetworkClient
//
//  Created by HanDong Wang on 2018/6/15.
//  Copyright © 2018年 HanDong Wang. All rights reserved.
//

import UIKit

protocol HDNetworkResultType: HDNetworkAPI {
    associatedtype ResultType: Codable
}
