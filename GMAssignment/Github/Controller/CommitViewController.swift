//
//  ViewController.swift
//  GMAssignment
//
//  Created by Ashish Patel on 5/17/21.
//

import UIKit

class CommitViewController: UIViewController, AlertDisplayer {
    
    private var viewModel: CommitViewModel?

    init(viewModel: CommitViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableview: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(CommitCell.self, forCellReuseIdentifier: "CommitCell")
        tableview.dataSource = self
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Swift Commits"
        setupTableview()
        viewModel?.fetchCommits()
    }
    
    // MARK: - Helper Functions
    func setupTableview() {
        view.addSubview(tableview)
        tableview.tableFooterView = createSpinnerFooter()
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: view.topAnchor),
            tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableview.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
}

extension CommitViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.commits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableview.dequeueReusableCell(withIdentifier: "CommitCell") as? CommitCell,
           let viewModel = viewModel {
            let commitForIndexPath = viewModel.commits[indexPath.row]
            cell.configure(with: commitForIndexPath)
            return cell
        }
        return UITableViewCell()
    }
}

extension CommitViewController: CommitViewModelDelegate {
    func onFetchCompleted() {
        DispatchQueue.main.async {
            self.tableview.reloadData()
            self.tableview.tableFooterView = nil
        }
    }
    
    func onFetchFailed(with reason: String) {
        let title = "Error"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title, message: reason, actions: [action])
    }
}
