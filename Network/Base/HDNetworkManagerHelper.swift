//
//  HDNetworkManagerHelper.swift
//  NetworkClient
//
//  Created by HanDong Wang on 2018/6/15.
//  Copyright © 2018年 HanDong Wang. All rights reserved.
//

import UIKit

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

func request<T: HDNetworkResultType>(_ api: T, _ success: @escaping (T.ResultType) -> Void, failure: @escaping (String) -> Void) {
    HDNetworkManager().request(api) { (data, response, error) in
        if error != nil {
            failure("Please check your network connection.")
        }
        
        if let response = response as? HTTPURLResponse {
            let result = handleNetworkResponse(response)
            switch result {
            case .success:
                guard let responseData = data else {
                    failure(NetworkResponse.noData.rawValue)
                    return
                }
                do {
                    print(responseData)
                    let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                    print(jsonData)
                    let apiResponse = try JSONDecoder().decode(T.ResultType.self, from: responseData)
                    success(apiResponse)
                }catch {
                    print(error)
                    failure(NetworkResponse.unableToDecode.rawValue)
                }
            case .failure(let networkFailureError):
                failure(networkFailureError)
            }
        }
    }
}

fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
    switch response.statusCode {
    case 200...299: return .success
    case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
    case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
    case 600: return .failure(NetworkResponse.outdated.rawValue)
    default: return .failure(NetworkResponse.failed.rawValue)
    }
}
