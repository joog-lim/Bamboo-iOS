//
//  GoogleOauthModalReactor.swift
//  bamboo-iOS
//
//  Created by Ji-hoon Ahn on 2021/12/04.
//

import ReactorKit
import RxFlow
import RxCocoa
import Network
import Moya
import KeychainSwift
import AuthenticationServices

final class OauthModalReactor : Reactor , Stepper{
    
    var disposeBag : DisposeBag = .init()
    
    var steps: PublishRelay<Step> = .init()
    
    enum Action{
        case googleLoginBERequied(idToken: String)
        case googleModalDismiss
        case appleLoginBERequest(result: ASAuthorizationAppleIDCredential)
    }
    enum Mutation{
        case setLogin(accessToken : String , refreshToken : String, isAdmin : Bool)
    }
    struct State{
        var access :String = .init()
        var refresh : String = .init()
        var isAdmin : Bool = .init()
    }
    let initialState: State
    let provider : ServiceProviderType
    
    init(with provider : ServiceProviderType){
        self.initialState = State()
        self.provider = provider
    }
}

//MARK: - Mutation
extension OauthModalReactor{
    func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case.googleModalDismiss:
            steps.accept(BambooStep.dismiss)
            return .empty()
        case let .googleLoginBERequied(idToken):
            return postLogin(idToken)
        case let .appleLoginBERequest(result):
            print(String(data: result.identityToken!, encoding: .utf8) ?? "")
            print("\(result.fullName?.familyName ?? "")\(result.fullName?.givenName ?? "")")
            steps.accept(BambooStep.otpLoginIsRequired)
            return .empty()
        }
    }
}
//MARK: - Reduce
extension OauthModalReactor{
    func reduce(state: State, mutation: Mutation) -> State {
        let new = state
        switch mutation{
        case let .setLogin(accessToken, refreshToken,isAdmin):
            KeychainSwift().set(accessToken, forKey: "accessToken")
            KeychainSwift().set(refreshToken, forKey: "refresgToken")
            print(isAdmin)
            UserDefaults.standard.set(isAdmin, forKey: "isAdmin")
            UserDefaults.standard.set(true, forKey: "LoginStatus")
            steps.accept(BambooStep.dismiss)
        }
        return new
    }
}

//MARK: - Method
private extension OauthModalReactor{
    func postLogin(_ idToken : String) -> Observable<Mutation>{
        return self.provider.loginService.postLogin(idToken: idToken)
            .map{ Mutation.setLogin(accessToken: $0.data.access, refreshToken: $0.data.refresh,isAdmin: $0.data.admin)}
    }
}