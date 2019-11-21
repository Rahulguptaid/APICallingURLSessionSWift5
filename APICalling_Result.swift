//
//  APICalling_Result.swift
//  Keys2Home_Agent
//
//  Created by appsDev on 21/11/19.
//  Copyright © 2019 appsDev. All rights reserved.
//

import UIKit

struct Post: Decodable {
    let title: String
    let body: String
}

enum NetworksError: Error {
    case domainError
    case decodingError
}

struct NetworksClass {
    let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    
    func fetchPosts(completion: @escaping (Result<[Post],NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                        completion(.failure(.domainError))
                }
                return
            }
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                completion(.success(posts))
            } catch {
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
    private init() {}
    static let shared : NetworksClass = {
        return NetworksClass()
    }()
}

class SampleViewModel : NSObject {
    
    func getData() {
        NetworksClass.shared.fetchPosts() { result in
            switch result {
                case .success(let posts):
                    print(posts)
                case .failure:
                    print("FAILED")
            }
        }
    }
    
}
