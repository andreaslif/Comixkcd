//
//  MockURLSessionDataTask.swift
//  Comixkcd
//
//  Created by Andreas on 2021-05-16.
//

import Foundation

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
