//
//  MockNetworkManager.swift
//  flickerSearchTests
//
//  Created by Mian on 9/23/24.
//

import Foundation
import Combine
@testable import flickerSearch
class MockNetworkManager: FSNetworkManagerProtocol{
    enum MockResponse {
        case success(Data)
        case failure(Error)
    }
    
    var mockResponse: MockResponse?
    
    func request(baseUrlString: String, pathString: String?, httpMethod: FSNetworkManager.HTTPMethod, body: Data?, headers: [String : String]?, queryParam: [String : String]?) -> AnyPublisher<Data, Error> {
        guard let mockResponse = mockResponse else {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
        
        switch mockResponse {
        case .success(let data):
            return Just(data)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
            
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}
