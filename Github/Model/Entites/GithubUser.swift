//
//  GithubUser.swift
//  Github
//
//  Created by Nadav Bar Lev on 10/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import Foundation

struct GithubUser: Decodable {
    
    // MARK: Properties
    let id: Int
    let username: String
    let avatarURL: String
    
    // MARK: Coding Keys
    enum CodingKeys: String, CodingKey {
        case id
        case username  = "login"
        case avatarURL = "avatar_url"
    }
   
}
