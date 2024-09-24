//
//  FSSearchViewIntentTests.swift
//  flickerSearchTests
//
//  Created by Mian on 9/23/24.
//

import XCTest
import Combine
@testable import flickerSearch

final class FSSearchViewIntentTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    private var model: FSSearchViewModel!
    private var intent: FSSearchViewIntent!
    private var mockNetworkManager: MockNetworkManager!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        model = FSSearchViewModel()
        cancellables = []
        mockNetworkManager = MockNetworkManager()
        intent = FSSearchViewIntent(model: model, networkManager: mockNetworkManager)
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables = nil
        model = nil
        intent = nil
    }
    func testUpdateKeyword() {
        let inputKeyword = "new word"
        intent.updateKeyword(inputKeyword)
        XCTAssertEqual(model.keyword, inputKeyword, "Keyword should be the same")
    }
    func testSearchImage_Success() {
        let fetchedItems = [
            ImageInfo(title: "Test1", media: Media(imagePath: "https://a.com/test1.jpg"), description: nil, author: nil, publishedDate: nil),
            ImageInfo(title: "Test2", media: Media(imagePath: "https://a.com/test2.jpg"), description: nil, author: nil, publishedDate: nil)
        ]
        
        let response = ImageResponse(items: fetchedItems)
        let responseData = try! JSONEncoder().encode(response)
        mockNetworkManager.mockResponse = .success(responseData)
        
        let expectation = self.expectation(description: "Search Image Success")
        
        intent.searchImage()
        intent.model.$items
            .sink { items in
                print("Received items: \(items)")
                XCTAssertEqual(items, fetchedItems, "Items should the same")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 2.0)
        
    }
    func testSearchImage_Failure() {
        mockNetworkManager.mockResponse = .failure(FSNetworkManager.NetworkError.parsingError)
        
        let expectation = self.expectation(description: "Search Image Failed")
        
        intent.searchImage()
        intent.model.$items
            .sink { items in
                XCTAssertEqual(items.count, 0, "Items should be 0")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    
}
