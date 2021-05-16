//
//  TestComicViewModel.swift
//  TestComicViewModel
//
//  Created by Andreas on 2021-05-15.
//

import XCTest
@testable import Comixkcd

class TestComicViewModel: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// Test that a ComicViewModel can be created correctly from a Comic object.
    func testViewModelCreation() throws {

        let testComic = Comic(month: "4",
                          num: 105,
                          link: "https://somelink.com",
                          year: "2021",
                          news: "Some news",
                          safe_title: "A safe title",
                          transcript: "A transcript",
                          alt: "An alternative caption",
                          img: "https://urltoanimage.com",
                          title: "A title",
                          day: "11")
        
        let comicViewModel = ComicViewModel(comic: testComic)
        
        XCTAssert(comicViewModel.date == "2021-04-11")
        XCTAssert(comicViewModel.title == "A title")
        XCTAssert(comicViewModel.alternativeCaption == "An alternative caption")
        XCTAssert(comicViewModel.number == 105)
        XCTAssert(comicViewModel.transcript == "A transcript")
        XCTAssert(comicViewModel.favourited == false)
    }
    
    // TODO: Add test for creating ComicViewModel from a NSManagedObject

}
