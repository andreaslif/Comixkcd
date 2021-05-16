//
//  MockURLSession.swift
//  Comixkcd
//
//  Created by Andreas on 2021-05-16.
//

import Foundation

/// An instance of this class can be used instead of an instance of an URLSession instance in order to fake a data response for testing purposes.
class MockURLSession: URLSession {
    
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    var data: Data?
    var error: Error?
    
    init(data: Data?, error: Error?) {
        
        self.data = data
        self.error = error
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {

        return MockURLSessionDataTask {
            completionHandler(self.data, nil, self.error)
        }
    }
    
}
