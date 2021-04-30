//
//  DefaultNetwork.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/28.
//

import Alamofire
import RxSwift
class DefaultNetwork {
    private let baseURL: String
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    func getObject<T: Decodable>(url: String, parameter: Parameters? = nil) -> Observable<T> {
        let fullURL = baseURL + url
        return Observable.create { (observer) -> Disposable in
            let request = AF.request(fullURL, method: .get, parameters: parameter)
            request.responseDecodable(of: T.self) { response in
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
}
