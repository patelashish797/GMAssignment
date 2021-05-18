//
//  CommitModel.swift
//  GMAssignment
//
//  Created by Ashish Patel on 5/18/21.
//

import Foundation

struct CommitList: Codable {
    let sha: String
    let commit: Commit
}

struct Commit: Codable {
    let author: Author
    let message: String
}

struct Author: Codable {
    let name: String
}
