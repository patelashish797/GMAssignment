//
//  CommitWebService.swift
//  GMAssignment
//
//  Created by Ashish Patel on 5/17/21.
//

import Foundation

class CommitWebService {
    
    private var urlSession: URLSession
    private var urlString: String
    
    init(urlString: String, urlSession: URLSession = .shared) {
        self.urlString = urlString
        self.urlSession = urlSession
    }
    
    func fetchListOfCommits(onCompition: @escaping (Result<[CommitList], APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            onCompition(.failure(.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                onCompition(.failure(APIError.failedRequest(description: "something went wrong, try again later.")))
                return
            }
            guard let data = data else {
                print("data is nil")
                onCompition(.failure(.dataIsNil))
                return
            }
            if let feedList = try? JSONDecoder().decode([CommitList].self, from: data) {
                onCompition(.success(feedList))
            } else {
                onCompition(.failure(.parshingEror))
                print("error in json parsing")
            }
        }
        task.resume()
        
    }
}



