//
//  GithubService.swift
//  Github
//
//  Created by Nadav Bar Lev on 10/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import RxSwift

// MARK: Github URLs
enum GithubURL {
    
    // MARK: Cases
    case userSearch(query: String)
    case topicSearch(query: String)
    
    // MARK: Computed Properties
    private var baseURL: String {
        return "https://api.github.com/"
    }
    
    private var token: String {
        return "2e40e1f8e809c765399671a1e872beda53fbb502"
    }
    
    var URL: String {
        switch self {
        case .userSearch(let query):
            return String(format: "%@search/users?q=%@&access_token=%@",
                          baseURL, query, token)
        case .topicSearch(let query):
            return String(format: "%@search/topics?q=%@&access_token=%@",
                          baseURL, query, token)
        }
    }
}

protocol ProtocolGithubService {
    func userSearch(query: String) -> Observable<GithubUserSearch>
}

class GithubService: ProtocolGithubService {
    
    // MARK: Methods
    func userSearch(query: String) -> Observable<GithubUserSearch> {
        return Network.request(method: .get,
                               url: GithubURL.userSearch(query: query).URL,
                               parameters: nil,
                               type: GithubUserSearch.self)
    }
}
