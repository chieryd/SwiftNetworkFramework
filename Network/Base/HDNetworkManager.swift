//
//  HDNetworkManager.swift
//  NetworkClient
//
//  Created by HanDong Wang on 2018/6/15.
//  Copyright © 2018年 HanDong Wang. All rights reserved.
//

import UIKit


public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

class HDNetworkManager<T: HDNetworkResultType> {
    private var task: URLSessionTask?
    
    func request(_ route: T, completion: @escaping NetworkRouterCompletion) {
        // 这里如果存在特殊配置 可以独立出去，同时在HDNetworkAPI中暴露需要的configure类型
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            HDNetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        }catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: T) throws -> URLRequest {
        
        var request = URLRequest(url: URL.init(string: route.url)!,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.method.rawValue
        do {
                switch route.task {
                    case .request:
                        self.addAdditionalHeaders(route.headers, request: &request)
                        try self.configureParameters(bodyParameters: route.parameters,
                                                     bodyEncoding: route.encoding,
                                                     urlParameters: nil,
                                                     request: &request)
                    
                    case .download:
                        print("之后才支持这种类型");
                    case .upload:
                        print("之后再支持这种类型");
                }
                return request
            } catch {
                throw error
            }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
