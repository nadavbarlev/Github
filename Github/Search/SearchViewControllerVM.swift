//
//  SearchViewModel.swift
//  Github
//
//  Created by Nadav Bar Lev on 13/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ProtocolSearchViewControllerVM {
    
    // MARK: Properties - View to Model
    var searchText: PublishSubject<String> { get }
    var cellDidSelect: PublishSubject<Int> { get }
    
    // MARK: Properties - Model to View
    var cellsModel: Observable<[UserTableViewCellVM]> { get }
    var resultCount: Observable<String> { get }
    var presentProfileVC: Observable<ProtocolProfileViewControllerVM> { get }
}

class SearchViewControllerVM: ProtocolSearchViewControllerVM {
    
    // MARK: Properties - View to Model
    var searchText = PublishSubject<String>()
    var cellDidSelect = PublishSubject<Int>()
    
    // MARK: Properties - Model to View
    var cellsModel: Observable<[UserTableViewCellVM]>
    var resultCount: Observable<String>
    var presentProfileVC: Observable<ProtocolProfileViewControllerVM>
    
    // MARK: Constructor
    init(githubService: ProtocolGithubService, commentService: ProtocolCommentService) {
       let searchResults = searchText
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest {
                githubService.userSearch(query: $0)
                .retry(3)
                .catchErrorJustReturn(GithubUserSearch.defVal)
            }
            .observeOn(MainScheduler.instance)
            .startWith(GithubUserSearch.defVal)
            .share(replay: 1)
        
        cellsModel = searchResults.map { (githubUserSearch: GithubUserSearch) in
            githubUserSearch.users.map { user in
                UserTableViewCellVM(imageURL: user.avatarURL, username: user.username)
            }
        }
        
        resultCount = searchResults.map { (githubUserSearch: GithubUserSearch) in
            String(format: "%d results", githubUserSearch.count)
        }
        
        presentProfileVC = cellDidSelect
            .withLatestFrom(searchResults) { index, results in
                ProfileViewControllerVM(githubUser: results.users[index], commentService: commentService)
            }
    }
}
