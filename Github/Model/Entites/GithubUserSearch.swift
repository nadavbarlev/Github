//
//  GithubUserSearch.swift
//  Github
//
//  Created by Nadav Bar Lev on 10/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import Foundation

struct GithubUserSearch: Decodable {
    
    static let defVal = GithubUserSearch(count: 0, users: [])
    
    // MARK: Properties
    let count: Int
    let users: [GithubUser]
    
    // MARK: Coding Keys
    enum CodingKeys: String, CodingKey {
        case count = "total_count"
        case users = "items"
    }
    
    // MARK: Constructor
    init(count: Int, users: [GithubUser]) {
        self.count = count
        self.users = users
    }
    
}
