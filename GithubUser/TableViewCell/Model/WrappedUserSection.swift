//
//  Model.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/30.
//


import Foundation
import RxDataSources

struct WrappedUserSection {
    var id: String
    var items: [WrappedUser]
    
    
}
extension WrappedUserSection: AnimatableSectionModelType, Equatable {
    static func == (lhs: WrappedUserSection, rhs: WrappedUserSection) -> Bool {
        lhs.items == rhs.items
    }
    typealias Item = WrappedUser
    init(original: WrappedUserSection, items: [Item]) {
        self = original
        self.items = items
    }
    
    var identity: String {
        return id
    }
}



