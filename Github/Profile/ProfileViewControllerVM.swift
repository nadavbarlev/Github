//
//  ProfileViewControllerVM.swift
//  Github
//
//  Created by Nadav Bar Lev on 14/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import RxSwift
import RxCocoa


protocol ProtocolProfileViewControllerVM {
    
    // MARK: Properties - View to VM
    var showCommentsDidTap: PublishSubject<Void> { get }
    
    // MARK: Properties - VM to View
    var presentCommentVC: Observable<ProtocolCommentsViewControllerVM> { get }
    var image: Observable<UIImage> { get }
    var username: String { get }  
}

class ProfileViewControllerVM: ProtocolProfileViewControllerVM {
   
    // MARK: Properties - View to Model
    var showCommentsDidTap = PublishSubject<Void>()
    
    // MARK: Properties - Model to View
    var image: Observable<UIImage>
    var username: String
    var presentCommentVC: Observable<ProtocolCommentsViewControllerVM>
    
    // MARK: Constructor
    init(githubUser: GithubUser, commentService: ProtocolCommentService) {
        let placeholder = UIImage(imageLiteralResourceName: "user_placeholder")
        let userImg = Network.image(url: githubUser.avatarURL)
                        .observeOn(MainScheduler.instance)
                        .catchErrorJustReturn(placeholder)
        
        username = githubUser.username
        image = Observable.just(placeholder)
                    .concat(userImg)
       presentCommentVC = showCommentsDidTap
            .map { CommentsViewControllerVM(commentService: commentService,
                                            username: githubUser.username) }
        
    }
    
}
