//
//  FSNetworkManager.swift
//  flickerSearch
//
//  Created by Mian on 9/23/24.
//

import Foundation
import Combine
//actual & mock managers should confrom to the protocol
protocol FSNetworkManagerProtocol {
    func request(baseUrlString: String, pathString: String?, httpMethod: FSNetworkManager.HTTPMethod, body: Data?, headers: [String: String]?, queryParam: [String: String]?) -> AnyPublisher<Data, Error>
}

class FSNetworkManager: NSObject, FSNetworkManagerProtocol {
    //make it singleton
    static let shared = FSNetworkManager()
    private override init() {
        super.init()
    }
    enum HTTPMethod: String {
        case GET
        case POST
        case DELETE
        case PUT
    }
    enum NetworkError: Error {
        case noData
        case invalidURL
        case parsingError
        case badResponse
    }
    func request(baseUrlString: String, pathString: String?, httpMethod: HTTPMethod, body: Data?, headers: [String: String]?, queryParam: [String: String]?) -> AnyPublisher<Data, Error> {
        //create url
        guard var urlComponents = URLComponents(string: baseUrlString + (pathString ?? "")) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        if let queryParam = queryParam {
            urlComponents.queryItems = queryParam.map{ URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        guard let url = urlComponents.url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        //make it a request
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.timeoutInterval = 10.0
        request.cachePolicy = .useProtocolCachePolicy
        
        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }
        if let body = body {
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        //send request and return a publisher
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) in
                //preprocess it, if bad response, throw error
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else{
                    throw NetworkError.badResponse
                }
                return data
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
    }
}
