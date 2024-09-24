//
//  FSSearchViewIntent.swift
//  flickerSearch
//
//  Created by V D on 9/23/24.
//

import Foundation
import Combine

class FSSearchViewIntent: FSIntent {
    typealias ModelType = FSSearchViewModel
    var model: FSSearchViewModel
    private var cancellables = Set<AnyCancellable>()
    private var networkManager: FSNetworkManagerProtocol
    
    init(model: FSSearchViewModel, networkManager: FSNetworkManagerProtocol) {
        self.model = model
        self.networkManager = networkManager
    }

    func updateKeyword(_ newKeyword: String) {
        self.model.keyword = newKeyword
    }
    func searchImage() {
        let queryParam: [String: String] = ["format": "json", "nojsoncallback":"1", "tags": self.model.keyword]
        networkManager.request(baseUrlString: "https://api.flickr.com", pathString: "/services/feeds/photos_public.gne", httpMethod: .GET, body: nil, headers: nil, queryParam: queryParam)
            .tryMap { data in
                let response: ImageResponse? = jsonDecoder(data: data)
                guard let items = response?.items else {
                    throw FSNetworkManager.NetworkError.parsingError
                }
                return items
            }
            .sink (receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Network Error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] items in
                self?.model.items = items
            })
            .store(in: &cancellables)
    }
}
