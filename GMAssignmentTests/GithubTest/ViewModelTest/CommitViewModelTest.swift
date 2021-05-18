//
//  CommitViewModelTest.swift
//  GMAssignmentTests
//
//  Created by Ashish Patel on 5/18/21.
//

import XCTest
@testable import GMAssignment

class CommitViewModelTest: XCTestCase, CommitViewModelDelegate{
    
    var sut: CommitViewModel!
    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        let commitWebService = CommitWebService(urlString: "https://api.github.com/repos/apple/swift/commits",
                                                urlSession: urlSession)
        sut = CommitViewModel(delegate: self, service: commitWebService)

    }
    
    override func tearDownWithError() throws {
        sut = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.error = nil
    }
    
    func testViewModel_WhenGivenInit_ReturnsEmptyCommitList() throws {
        XCTAssertTrue(sut.commits.isEmpty, "Commits should be empty")
    }
    
    func testViewModel_WhenGivenSuccessfulResponse_CallsFetchCompleted() throws {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "GithubCommits", ofType: "json") else {
            fatalError("GithubCommits.json not found")
        }

        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert GithubCommits.json to String")
        }
        
        
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        expectation = self.expectation(description: "Github Web Service Response Expectation")

        sut.fetchCommits()
        self.wait(for: [expectation], timeout: 5)
        XCTAssertFalse(sut.commits.isEmpty)
        XCTAssertEqual(sut.commits[0].sha, "4886bd56e45747a75228cf5c760d765457e572d3")
        XCTAssertEqual(sut.commits[0].commit.author.name, "Philippe Hausler")
    }


    func testViewModel_WhenGivenIncorrectJsonReaspose_callsFetchFailed() throws {
        let jsonString = "{\"path\":\"/users\", \"error\":\"Internal Server Error\"}"
        MockURLProtocol.stubResponseData =  jsonString.data(using: .utf8)
        expectation = self.expectation(description: "Github Web Service Response Expectation")

        sut.fetchCommits()
        self.wait(for: [expectation], timeout: 5)
        XCTAssertTrue(sut.commits.isEmpty, "Commits should be empty")
    }
    
    
    func onFetchCompleted() {
        expectation.fulfill()
    }
    
    func onFetchFailed(with reason: String) {
        expectation.fulfill()
    }

}
