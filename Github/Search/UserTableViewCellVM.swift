//
//  UserTableViewCellViewModel.swift
//  Github
//
//  Created by Nadav Bar Lev on 13/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import RxSwift

class UserTableViewCellVM {
    
    // MARK: Constants
    let placeholder = UIImage(imageLiteralResourceName: "user_placeholder")
    
    // MARK: Properties - Model to View
    let image: Observable<UIImage>
    let username: String
    
    // MARK: Constructor    
    init(imageURL: String, username: String) {
        
        let userImage = Network.image(url: imageURL)
        self.username = username
        self.image = Observable.just(placeholder)
            .concat(userImage)
    }
    
}