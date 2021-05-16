//
//  MockURLSessionDataTask.swift
//  Comixkcd
//
//  Created by Andreas on 2021-05-16.
//

import Foundation

/// An instance of this class can be used instead of an instance of an URLSessionDataTask instance in order to fake a data response for testing purposes.
class MockURLSessionDataTask: URLSessionDataTask {
    
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    // Override resume and call the closure
    override func resume() {
        closure()
    }
    
}
