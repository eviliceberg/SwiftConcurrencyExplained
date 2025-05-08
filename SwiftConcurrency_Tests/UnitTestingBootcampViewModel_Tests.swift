//
//  UnitTestingBootcampViewModel_Tests.swift
//  SwiftConcurrency_Tests
//
//  Created by Artem Golovchenko on 2025-05-07.
//

import XCTest
@testable import SwiftConcurrency
import Combine

//naming structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
//naming structure: test_[struct or class]_[variable or function]_[expected result]

//Testing Structure: Given, When, Then

@MainActor
final class UnitTestingBootcampViewModel_Tests: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []
    var vm: UnitTestingBootcampViewModel?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        vm = nil
    }

    func test_UnitTestingBootcampViewModel_isPremium_ShouldBeTrue() async {
        
        //Given
        
        let value: Bool = true
        
        //When
        let vm = UnitTestingBootcampViewModel(isPremium: value)
        
        //Then
        XCTAssertTrue(vm.isPremium)
    }
    
    func test_UnitTestingBootcampViewModel_isPremium_ShouldBeFalse() {
        
        //Given
        
        let value: Bool = false
        
        //When
        let vm = UnitTestingBootcampViewModel(isPremium: value)
        
        //Then
        XCTAssertFalse(vm.isPremium)
    }
    
    func test_UnitTestingBootcampViewModel_isPremium_ShouldBeInjectedValue() {
        
        //Given
        
        let value: Bool = Bool.random()
        
        //When
        let vm = UnitTestingBootcampViewModel(isPremium: value)
        
        //Then
        XCTAssertEqual(vm.isPremium, value)
    }
    
    func test_UnitTestingBootcampViewModel_isPremium_ShouldBeInjectedValue_Stress() {
        
        for _ in 0..<100 {
            //Given
            
            let value: Bool = Bool.random()
            
            //When
            let vm = UnitTestingBootcampViewModel(isPremium: value)
            
            //Then
            XCTAssertEqual(vm.isPremium, value)
        }
    }
    
    func test_UnitTestingBootcampViewModel_dataArray_ShouldBeEmpty() {
        
        //Given
        
        
        //When
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        
        //Then
        XCTAssertEqual(vm.dataArray, [])
        
    }
    
    func test_UnitTestingBootcampViewModel_dataArray_ShouldAddItems() {
        
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
       // let item = UUID().uuidString
        
        //When
        let loopCount: Int = Int.random(in: 1...100)
        
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        //Then
        XCTAssertTrue(!vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, loopCount)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    
    func test_UnitTestingBootcampViewModel_dataArray_ShouldNotAddBlancString() {
        
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        let item = ""
        //When
        vm.addItem(item: item)
        
        //Then
        XCTAssertTrue(vm.dataArray.isEmpty)
       // XCTAssertTrue(vm.dataArray.contains(item))
        XCTAssertEqual(vm.dataArray.count, 0)
       // XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    
    func test_UnitTestingBootcampViewModel_dataArray_ShouldNotAddBlancString2() {
        
        //Given
        guard let vm = vm else {
            XCTFail()
            return
        }
        let item = ""
        //When
        vm.addItem(item: item)
        
        //Then
        XCTAssertTrue(vm.dataArray.isEmpty)
       // XCTAssertTrue(vm.dataArray.contains(item))
        XCTAssertEqual(vm.dataArray.count, 0)
       // XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    
    func test_UnitTestingBootcampViewModel_selectedItem_ShouldStartAsNil() {
        
        //Given
       

        //When
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        
        //Then
        XCTAssertTrue(vm.selectedItem == nil)
        XCTAssertNil(vm.selectedItem)
    }
    
    func test_UnitTestingBootcampViewModel_selectedItem_ShouldNotBeNil() {
        
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())

        //When
        let item = UUID().uuidString
        vm.addItem(item: item)
        vm.selectItem(item: item)
        
        //Then
        XCTAssertTrue(vm.selectedItem != nil)
        XCTAssertNotNil(vm.selectedItem)
    }
    
    func test_UnitTestingBootcampViewModel_selectedItem_ShouldNotNilWhenItemIsInvalid() {
        
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())

        //When
        let item = UUID().uuidString
        vm.addItem(item: item)
        vm.selectItem(item: item)
        vm.selectItem(item: UUID().uuidString)
        
        //Then
        XCTAssertTrue(vm.selectedItem == nil)
        XCTAssertNil(vm.selectedItem)
    }
    
    func test_UnitTestingBootcampViewModel_selectedItem_ShouldNotBeNil_Stress() {
        
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())

        //When
        let loopCount: Int = Int.random(in: 0...100)
        var itemsArray: [String] = []
        
        for _ in 0..<loopCount {
            let item = UUID().uuidString
            vm.addItem(item: item)
            itemsArray.append(item)
        }
        
        guard let randomItem = itemsArray.randomElement() else {
            XCTAssertTrue(!itemsArray.isEmpty)
            return
        }
        vm.selectItem(item: randomItem)
        
        
        //Then
        XCTAssertTrue(vm.selectedItem != nil)
        XCTAssertNotNil(vm.selectedItem)
        XCTAssertEqual(vm.selectedItem, randomItem)
    }
    
    func test_UnitTestingBootcampViewModel_saveItem_ShouldThrowError_noItemsFound() {
        
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())

        //When
        let loopCount: Int = Int.random(in: 0...100)
        
        for _ in 0..<loopCount {
            let item = UUID().uuidString
            vm.addItem(item: item)
        }
        
        //Then
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString))
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString), "Should throw Item not found error") { error in
            let returnedError = error as? DataError
            XCTAssertEqual(returnedError, DataError.itemNotFound)
        }
    }
    
    func test_UnitTestingBootcampViewModel_saveItem_ShouldThrowError_noData() {
        
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())

        //When
        let loopCount: Int = Int.random(in: 0...100)
        
        for _ in 0..<loopCount {
            let item = UUID().uuidString
            vm.addItem(item: item)
        }
        
        //Then
        do {
            try vm.saveItem(item: "")
        } catch {
            let returnedError = error as? DataError
            XCTAssertEqual(returnedError, DataError.noData)
        }
    }
    
    func test_UnitTestingBootcampViewModel_saveItem_ShouldSaveItem() {
        
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())

        //When
        let loopCount: Int = Int.random(in: 0...100)
        var itemsArray: [String] = []
        
        for _ in 0..<loopCount {
            let item = UUID().uuidString
            vm.addItem(item: item)
            itemsArray.append(item)
        }
        
        guard let randomItem = itemsArray.randomElement() else {
            XCTAssertTrue(!itemsArray.isEmpty)
            return
        }
        
        //Then
        XCTAssertNoThrow(try vm.saveItem(item: randomItem))
        do {
            try vm.saveItem(item: randomItem)
        } catch {
            XCTFail()
        }
    }
    
    func test_UnitTestingBootcampViewModel_downloadEscaping_ShouldReturnItems() {
        
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())

        //When
        let expectation = XCTestExpectation(description: "Should return items after 3 seconds")
        
        vm.downloadEscaping()
        
        vm.$dataArray
            .dropFirst() //drop fisrt publish because during init() it has initial value of []
            .sink { items in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        //Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    
    func test_UnitTestingBootcampViewModel_downloadCombine_ShouldReturnItems() {
        
        //Given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())

        //When
        let expectation = XCTestExpectation(description: "Should return items after 1 second")
        
        vm.downloadCombine()
        
        vm.$dataArray
          //  .dropFirst() //drop fisrt publish because during init() it has initial value of []
            .sink { items in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        //Then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    
}
