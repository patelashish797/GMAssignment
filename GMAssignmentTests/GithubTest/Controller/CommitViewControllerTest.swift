//
//  CommitViewControllerTest.swift
//  GMAssignmentTests
//
//  Created by Ashish Patel on 5/18/21.
//

import XCTest
@testable import GMAssignment

class CommitViewControllerTest: XCTestCase {
    
    var sut: CommitViewController!
    var expectation: XCTestExpectation!
    var viewModel: CommitViewModel!
    
    override func setUpWithError() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        let service = CommitWebService(urlString: "https://api.github.com/repos/apple/swift/commits", urlSession: urlSession)
        viewModel = CommitViewModel(service: service)
        sut = CommitViewController(viewModel: viewModel)
        viewModel.delegate = sut
        
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testViewController_WhenGivenInit_InitinitialisesTableview() throws {
        //given when then
        XCTAssertNotNil(sut.tableview)
    }
    
    func testViewController_WhenGivenCommits_DisplayInTableviewCell() throws {
        //given
        viewModel.commits.append(CommitList(sha: "SHA", commit: Commit(author: Author(name: "Name"), message: "Message")))
        
        //when
        sut.tableview.reloadData()
        let cell = sut.tableview.cellForRow(at: IndexPath(row: 0, section: 0)) as! CommitCell
        
        //then
        XCTAssertTrue(viewModel.commits.count == 1)
        XCTAssertEqual(cell.authorNameLabel.text, "Name")
        XCTAssertEqual(cell.commitMessageLabel.text, "Message")
        XCTAssertEqual(cell.commitHashLabel.text, "SHA")
        
    }
    
}
