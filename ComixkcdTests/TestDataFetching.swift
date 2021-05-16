//
//  TestDataFetching.swift
//  ComixkcdTests
//
//  Created by Andreas on 2021-05-16.
//

import XCTest
@testable import Comixkcd

class TestDataFetching: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Data Fetching
    
    /// Test the data fetching process by mocking the data
    func testDataFetchReturningData() {
        
        let url = URL(string: "FakeURL")
        
        let comicJsonObject: [String : Any]  = [
            "month" : "11",
            "num" : 143,
            "link" : "https://somelink.com",
            "year" : "2021",
            "news" : "Some news",
            "safe_title" : "A safe title",
            "transcript" : "A transcript",
            "alt" : "An alternative title",
            "img" : "https://someimageurl.com",
            "title" : "A title",
            "day" : "5"]

        var data: Data?
        
        do {
            data = try JSONSerialization.data(withJSONObject: comicJsonObject, options: [])
        } catch {
            print("Failed to create data from JSON")
            XCTFail()
        }
        
        let mockUrlSession = MockURLSession(data: data, error: nil)
        
        let expectation = self.expectation(description: "Fetching data")
        
        ComicService.shared.fetchComicFrom(url: url!, with: mockUrlSession, completionHandler: { comic, error in

            XCTAssert(comic != nil)
            XCTAssert(error == nil)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 1)
    }
    
    /// Test that we can handle a failure to parse the JSON, e.g. if the data we receive is not in the expected format.
    func testFetchingBadData() {
        
        // The URL will be ignored by the mock session, so it doesn't matter
        let url = URL(string: "FakeURL")
        
        // We don't have to use real data, since the service should be able to handle incorrect formats and still return default values.
        let data = "Bad data".data(using: .ascii)
        
        let mockUrlSession = MockURLSession(data: data, error: nil)
                
        ComicService.shared.fetchComicFrom(url: url!, with: mockUrlSession, completionHandler: { comic, error in
            
            XCTAssert(comic == nil)
            XCTAssert(error != nil)
        })
    }
    
    /// Test the complete data fetching process, including contact with the server and waiting for a response.
    func testFetchingWithServerConnection() {
                
        if Config.shouldTestServerConnection {
            
            let url = ComicService.shared.urlForLatestComic()
            
            let expectation = self.expectation(description: "Loading URL")
            
            ComicService.shared.fetchComicFrom(url: url!, with: URLSession.shared, completionHandler: { comic, error in
                
                XCTAssert(error == nil)
                XCTAssert(comic != nil)
                
                expectation.fulfill()
            })
            
            waitForExpectations(timeout: 10)
        }
    }

    // MARK: - URLs
    
    /// Test that URL creation returns valid URLs.
    func testURLCreation() {

        if ComicService.shared.urlForLatestComic() != nil {
            XCTAssert(true)
        } else {
            XCTFail()
        }
        
        if ComicService.shared.urlForComic(number: 12) != nil {
            XCTAssert(true)
        } else {
            XCTFail()
        }
    }

}
