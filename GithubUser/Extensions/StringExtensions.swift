//
//  StringExtension.swift
//  GithubUser
//
//  Created by JaeBin on 2021/04/30.
//

import Foundation
extension String {
    var toURL: URL? {
        URL(string: self)
    }
    var emptyNil: String? {
        isEmpty ? nil : self
    }
}
