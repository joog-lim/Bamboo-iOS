//
//  BamBooAPI+Method.swift
//  bamboo-iOS
//
//  Created by Ji-hoon Ahn on 2022/01/03.
//

import Foundation
import Moya

extension BamBooAPI{
    func getMethod() -> Moya.Method{
        switch self{
        case .getAlgorithem:
            return  .get
        case .getRule:
            return .get
        }
    }
}