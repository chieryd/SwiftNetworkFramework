# swift 网络框架

之前网络框架使用的是alamofire + codableAlamofire + promiseKit的方式。但是当前的工程就是相当的轻量级的工程。所以希望能将这些依赖完全的去除。

所以此次的设计都是使用的原生的API

1、NSURLSession来发起网络请求
2、protocol的方式来管理UI
3、enum的方式来处理不同的结果
4、codable完成json到model的转化
5、extension的方式统一请求的规范

### 请求的效果

这里success的返回对象直接是model类型，可以直接做.取值

	// 这里是简单的调用入口
    HDNetwork.test.init(userName: "汪汉 东", password: "1111").sendRequest({ (result) in
        print("返回了结果")
    }) { (error) in
        print("网络出错了： \(error)")
    }

### 1、NSURLSession来发起网络请求

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
	
### 2、protocol的方式来管理UI

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
	
### 3、enum的方式来处理不同的结果

	public enum HTTPMethod: String {
	    case get     = "GET"
	    case post    = "POST"
	    case put     = "PUT"
	    case patch   = "PATCH"
	    case delete  = "DELETE"
	}
	
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
	
### 4、codable完成json到model的转化

这里通过associate的方式保留请求结果的类型，在正真的请求是才去实例化需要转换的对象

	protocol HDNetworkResultType: HDNetworkAPI {
	    associatedtype ResultType: Codable
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
	
### 5、extension的方式统一请求的规范

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