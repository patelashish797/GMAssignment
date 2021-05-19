//
//  CommitCellTest.swift
//  GMAssignmentTests
//
//  Created by Ashish Patel on 5/18/21.
//

import XCTest
@testable import GMAssignment

class CommitCellTest: XCTestCase {
    
    var sut: CommitCell!

    override func setUpWithError() throws {
        sut = CommitCell(style: .default, reuseIdentifier: "CommitCell")
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testCommitCell_WhenInit_InitinitialisesProperties() throws {
        //given when then
        XCTAssertNotNil(sut.authorNameLabel)
        XCTAssertNotNil(sut.commitMessageLabel)
        XCTAssertNotNil(sut.commitHashLabel)
    }
    
    func testCommitCellConfigure_WhenGivenCommitList_SetsValuesOfProperties() throws {
        //given
        let commitList = CommitList(sha: "sha", commit: Commit(author: Author(name: "name"), message: "message"))
        
        //when
        sut.configure(with: commitList)
        
        //then
        XCTAssertEqual(sut.authorNameLabel.text, "name")
        XCTAssertEqual(sut.commitHashLabel.text, "sha")
        XCTAssertEqual(sut.commitMessageLabel.text, "message")
    }
}
