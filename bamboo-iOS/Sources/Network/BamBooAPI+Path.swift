//
//  BamBooAPI+Path.swift
//  bamboo-iOS
//
//  Created by Ji-hoon Ahn on 2022/01/03.
//

import Foundation

extension BamBooAPI {
  func getPath() -> String {
    switch self {
    case .postLogin:
        return "login"
    case .postBulletin:
        return "algorithm/"
    case .postRenewalToken:
        return  "token"
//User
    case .getAlgorithm:
        return "algorithm/list/page"
    case .getRule:
        return "algorithm/rule"
    case .getVerify:
        return "verify"
//manager
    case .getAdminAlgorithm:
        return "algorithm/list/page/admin"
    }
  }
}
