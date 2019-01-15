//
//  CommentsViewControllerVM.swift
//  Github
//
//  Created by Nadav Bar Lev on 15/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import RxSwift

protocol ProtocolCommentsViewControllerVM {
    
    // MARK: Properties - Model to View [Observables]
    var cellsModel: Observable<[String]> { get }
    var submitEnabled: Observable<Bool> { get }
    
    // MARK: Properties - View to Model [Observers]
    var submitDidTap: PublishSubject<Void> { get }
    var textComment: PublishSubject<String> { get }
}

class CommentsViewControllerVM: ProtocolCommentsViewControllerVM {
    
    // MARK: Properties
    let disposeBag = DisposeBag()
    
    // MARK: Properties - Model to View [Observables]
    let cellsModel: Observable<[String]>
    let submitEnabled: Observable<Bool>
    
    // MARK: Properties - View to Model [Observers]
    let submitDidTap = PublishSubject<Void>()
    let textComment = PublishSubject<String>()
    
    // MARK: Constructor
    init(commentService: ProtocolCommentService, username: String) {
        
        submitEnabled = textComment.map { $0.count > 0 }
                            .startWith(false)
        
        cellsModel = commentService.comments(for: username)
                        .observeOn(MainScheduler.instance)
        
        submitDidTap
            .withLatestFrom(textComment)
            .subscribe(onNext: { (text: String) in
                commentService.comment(text, for: username)
            }).disposed(by: disposeBag)
    }
}
