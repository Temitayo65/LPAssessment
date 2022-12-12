//
//  SimpleiOSAppTests.swift
//  SimpleiOSAppTests
//
//  Created by ADMIN on 11/12/2022.
//

import XCTest


@testable import SimpleiOSApp



final class SimpleiOSAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testAPICaller(){
        let apiCaller = APICaller() // on initialization the page count should be 1
        XCTAssertEqual(apiCaller.getPageCount(), 1, "The page count should be 1 on initialization")
        
        // To check that the page count is reset to 1 when this is called
        apiCaller.resetPageCount()
        XCTAssertTrue(apiCaller.getPageCount() == 1, "This value should always be 1 when the resetPageCount() has been called. Check the body of the function and set page count back to 1")
        
        var tableViewResult = [Items]()
        
        apiCaller.getSearchResults(for: "test"){result in
            switch result{
            case .success(let results):
                tableViewResult.append(contentsOf: results.items)
            case .failure(_):
                break
            }
            XCTAssertTrue(tableViewResult.count == 10, "Only 10 items should be received from network call. Change per_page to 10 if this error shows")
            XCTAssertEqual(apiCaller.getPageCount(), 2, "On the first call, the page number should have increased to 2 to enable second page loading for scrollView")
        }
        
        let query = "hello world"
        XCTAssertEqual(apiCaller.modifyQuery(with: query), "hello")
        
        let anotherQuery = "helloworld"
        XCTAssertEqual(apiCaller.modifyQuery(with: anotherQuery), "helloworld")

    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
