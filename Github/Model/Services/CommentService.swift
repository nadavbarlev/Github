//
//  CommentService.swift
//  Github
//
//  Created by Nadav Bar Lev on 10/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import RxSwift

// MARK: Enum - Comment Path
enum CommentPath {
    
    // MARK: Cases
    case comment(_ comment: String, username: String)
    case comments(username: String)
    
    // MARK: Computed Properties
    private var basePath: String {
        return "users/%@/comments"
    }
    
    var path: String {
        switch self {
        case .comment(let comment, let username):
            return String(format: "%@/%@",
                          CommentPath.comments(username: username).path, comment)
        case .comments(let username):
            return String(format: basePath, username)
        }
    }
}

protocol ProtocolCommentService {
    func comments(for username: String) -> Observable<[String]>
    func comment(_ comment: String, for username: String)
}

class CommentService: ProtocolCommentService {
    
    // MARK: Properties
    let disposeBag = DisposeBag()
    
    // MARK: Methods
    func comments(for username: String) -> Observable<[String]> {
        return Observable.create { observer in
            let commentsPath = String(format: "users/%@/comments", username)
            let commentsObserable = ServiceManager.database.observeToValue(path: commentsPath)
            commentsObserable.subscribe { event in
                switch (event) {
                case .next(let value):
                    guard let comments = value as? [String:Any] else { return }
                    observer.onNext(Array(comments.keys))
                default:
                    return
                }
            }.disposed(by: self.disposeBag)
            
            return Disposables.create {
                return
            }
        }
    }
    
    func comment(_ comment: String, for username: String) {
        let pathComment = CommentPath.comment(comment, username: username).path
        ServiceManager.database.setValue(path: pathComment, value: true)
    }
}
