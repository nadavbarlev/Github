//
//  Network.swift
//  Github
//
//  Created by Nadav Bar Lev on 10/01/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import RxSwift
import Alamofire

// MARK: Network Protocol
protocol NetworkService {
    static func image(url: String) -> Observable<UIImage>
    static func request(method: NetworkMethod, url: String, parameters: [String : Any]?) -> Observable<Data>
    static func request<T: Decodable>(method: NetworkMethod, url: String, parameters: [String : Any]?, type: T.Type) -> Observable<T>
}

final class Network: NetworkService {
  
    // MARK: Methods
    static func request(method: NetworkMethod, url: String, parameters: [String : Any]?) -> Observable<Data> {
        return Observable.create { observer in
            let request = Alamofire.request(url, method: method.httpMethod(), parameters: parameters)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    static func request<T: Decodable>(method: NetworkMethod, url: String, parameters: [String : Any]?, type: T.Type) -> Observable<T> {
         return request(method: method, url: url, parameters: parameters)
            .map {
                do {
                    return try JSONDecoder().decode(T.self, from: $0)
                }
                catch {
                    throw NetworkError.IncorrectDataReturned
                }
            }
    }
    
    static func image(url: String) -> Observable<UIImage> {
        return Observable.create { observer in
            let request = Alamofire.request(url, method: .get)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        guard let image = UIImage(data: data) else {
                            observer.onError(NetworkError.IncorrectDataReturned)
                            return
                        }
                        observer.onNext(image)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }

}
