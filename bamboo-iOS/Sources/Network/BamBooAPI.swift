//
//  BamBooAPI.swift
//  bamboo-iOS
//
//  Created by Ji-hoon Ahn on 2022/01/03.
//

import Moya
import Alamofire

enum BamBooAPI {
    //System
    case postRenewalToken(refreshToken : String)
    //Login
    case postLogin(loginRequest : LoginRequest)
    
    //User
    case getAlgorithm(algorithmRequest : AlgorithmRequest)
    case getRule
    case getVerify
    case postEmoji(emojiRequest : EmojiRequest) 
    
    case postBulletin(bulletinRequest : BulletinRequest)
    case patchStatus(statusRequest : EditStatusRequest, idx : Int)
    //Manager
    case getAdminAlgorithm(algorithmRequest : AdminAlgorithmRequest)
    case patchEditAlgorithm(editRequest : EditAlgorithmRequest, idx : Int)
    
}

extension BamBooAPI : Moya.TargetType{
    var baseURL: URL { self.getBaseURL()}
    var path: String { self.getPath()}
    var method: Moya.Method { self.getMethod() }
    var sampleData: Data {Data()}
    var task: Task { self.getTask()}
    var headers: [String : String]? {self.getHeader()}
    var validationType: ValidationType{ return .successCodes}
}
