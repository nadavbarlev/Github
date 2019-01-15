//
//  FirebaseDatabase.swift
//  Github
//
//  Created by Nadav Bar Lev on 10/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import RxSwift
import Firebase
import FirebaseDatabase

class FirebaseDatabase: DatabaseService {
    
    // MARK: Computed Properties
    let dbRef = Database.database().reference()
    
    // MARK: Methods
    func observeToValue(path: String) -> Observable<Any>  {
        return Observable.create { (observer: AnyObserver) in
            let pathRef = self.dbRef.child(path)
            let handleRef = pathRef.observe(.value) { (snapshot: DataSnapshot) in
                guard let value = snapshot.value else { return }
                observer.onNext(value)
            }
            return Disposables.create {
                pathRef.removeObserver(withHandle: handleRef)
            }
        }
    }
    
    func setValue(path: String, value: Any) {
        dbRef.child(path).setValue(value)
    }
    
}
