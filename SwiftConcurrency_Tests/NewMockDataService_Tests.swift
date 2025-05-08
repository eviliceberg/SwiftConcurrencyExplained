//
//  NewMockDataService_Tests.swift
//  SwiftConcurrency_Tests
//
//  Created by Artem Golovchenko on 2025-05-08.
//

import XCTest
@testable import SwiftConcurrency
import Combine

final class NewMockDataService_Tests: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables.removeAll()
    }

    func test_NewMockDataService_init_doesNotThrow() {
        //Given
        let items: [String]? = nil
        let items2: [String]? = []
        let items3: [String]? = [UUID().uuidString, UUID().uuidString]
       
        //When
        let manager = NewMockDataService(items: items)
        let manager2 = NewMockDataService(items: items2)
        let manager3 = NewMockDataService(items: items3)
        //Then
        
        XCTAssertTrue(!manager.items.isEmpty)
        XCTAssertTrue(manager2.items.isEmpty)
        XCTAssertEqual(manager3.items.count, items3?.count)
    }
    
    func test_NewMockDataService_downloadItemsEscaping_doesReturnValues() {
        //Given
        let manager = NewMockDataService(items: nil)
       
        //When
        let expectation = XCTestExpectation()
        
        
        var savedItems: [String] = []
        manager.downloadItems { items in
            savedItems = items
            expectation.fulfill()
        }

        //Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(manager.items, savedItems)
    }
    
    func test_NewMockDataService_downloadItemsCombine_doesReturnValues() {
        //Given
        let manager = NewMockDataService(items: nil)
       
        //When
        let expectation = XCTestExpectation()
        
        var items: [String] = []
        
        manager.downloadItemsCombine()
            .sink { comp in
                switch comp {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail()
                }
            } receiveValue: { rItems in
                items = rItems
            }
            .store(in: &cancellables)
        
        //Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(manager.items, items)
    }
    
    func test_NewMockDataService_downloadItemsCombine_doesFail() {
        //Given
        let manager = NewMockDataService(items: [])
       
        //When
        let expectation = XCTestExpectation()
        let expectation2 = XCTestExpectation(description: "Throws url error")
        
        var items: [String] = []
        var returnedError: URLError? = nil
        manager.downloadItemsCombine()
            .sink { comp in
                switch comp {
                case .finished:
                    XCTFail()
                case .failure(let error):
                    returnedError = error as? URLError
                    expectation.fulfill()
                    
                    if returnedError == URLError(.badURL) {
                        expectation2.fulfill()
                    }
                }
            } receiveValue: { rItems in
                items = rItems
            }
            .store(in: &cancellables)
        
        //Then
        wait(for: [expectation, expectation2], timeout: 5)
        XCTAssertEqual(manager.items, items)
        XCTAssertEqual(returnedError, URLError(.badURL))
    }

}
