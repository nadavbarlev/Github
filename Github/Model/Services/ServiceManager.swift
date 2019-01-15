//
//  ServiceManager.swift
//  Github
//
//  Created by Nadav Bar Lev on 13/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import RxSwift

class ServiceManager {
    
    static let network : NetworkService  = Network()
    static let database: DatabaseService = FirebaseDatabase()
    
}

// MARK: Service Protocols
protocol DatabaseService {
    func setValue(path: String, value: Any)
    func observeToValue(path: String) -> Observable<Any>
}
