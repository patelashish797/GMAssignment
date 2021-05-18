//
//  CommitViewModel.swift
//  GMAssignment
//
//  Created by Ashish Patel on 5/18/21.
//

import Foundation

protocol CommitViewModelDelegate: class {
    func onFetchCompleted()
    func onFetchFailed(with reason: String)
}

class CommitViewModel {
    private weak var delegate: CommitViewModelDelegate?
    private var service: CommitWebService?
    var commits: [CommitList] = []
    
    init(delegate: CommitViewModelDelegate,  service: CommitWebService) {
        self.delegate = delegate
        self.service = service
    }
    
    func fetchCommits() {
        service?.fetchListOfCommits(onCompition: { [weak self] (result) in
            switch result {
            case .success(let commits):
                self?.commits.append(contentsOf: commits)
                self?.delegate?.onFetchCompleted()
            case .failure(let error):
                self?.delegate?.onFetchFailed(with: error.errorDescription)
            }
        })
    }
}

