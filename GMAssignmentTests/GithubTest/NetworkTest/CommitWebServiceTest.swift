//
//  CommitWebServiceTest.swift
//  GMAssignmentTests
//
//  Created by Ashish Patel on 5/17/21.
//

import XCTest
@testable import GMAssignment

class CommitWebServiceTest: XCTestCase {
    
    var sut: CommitWebService!

    override func setUpWithError() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        sut = CommitWebService(urlString: "https://api.github.com/repos/apple/swift/commits", urlSession: urlSession)
    }

    override func tearDownWithError() throws {
        sut = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.error = nil

    }

    func testService_WhenGivenSuccessfullResponse_ReturnsCommitList() throws {
        //given
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "GithubCommits", ofType: "json") else {
            fatalError("GithubCommits.json not found")
        }
        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert GithubCommits.json to String")
        }
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        
        //when
        let expectation = self.expectation(description: "Signup Web Service Response Expectation")
        sut.fetchListOfCommits { (result) in
            //then
            switch result {
            case .success(let commits):
                XCTAssertEqual(commits[0].sha, "4886bd56e45747a75228cf5c760d765457e572d3")
            case .failure(let error):
                XCTFail("Error was not expected: \(error)")
            }
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)
    }
    
    func testService_WhenGivenInvalidURLString_ReturnsURLError() throws {
        //given
        sut = CommitWebService(urlString: "")
        
        //when
        let expectation = self.expectation(description: "Invalid URL Error Expectation")
        sut.fetchListOfCommits { (result) in
            //then
            switch result {
            case .success(let commits):
                XCTFail("success was not expected: \(commits)")
            case .failure(let error):
                XCTAssertEqual(error, APIError.urlError)
            }
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)
    }
    
    func testService_WhenGivenErrorResponse_ReturnsError() throws {
        //given
        MockURLProtocol.error = APIError.failedRequest(description: "something went wrong, try again later.")

        //when
        let expectation = self.expectation(description: "Signup Web Service Error Expectation")
        sut.fetchListOfCommits { (result) in
            //then
            switch result {
            case .success(let commits):
                XCTFail("success was not expected: \(commits)")
            case .failure(let error):
                XCTAssertEqual(error, APIError.failedRequest(description: "something went wrong, try again later."))
            }
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)
    }
    
    func testService_WhenGivenDifferentJSONResponse_ReturnsParshingEror() throws {
        //given
        let jsonString = "{\"status\":\"ok\"}"
        MockURLProtocol.stubResponseData =  jsonString.data(using: .utf8)

        //when
        let expectation = self.expectation(description: "Signup Web Service Error Expectation")
        sut.fetchListOfCommits { (result) in
            //then
            switch result {
            case .success(let commits):
                XCTFail("success was not expected: \(commits)")
            case .failure(let error):
                XCTAssertEqual(error, APIError.parshingEror)
            }
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)

    }
    
}
