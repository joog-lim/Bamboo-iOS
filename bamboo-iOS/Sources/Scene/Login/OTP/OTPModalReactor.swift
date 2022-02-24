//
//  OTPModalReactor.swift
//  bamboo-iOS
//
//  Created by Ji-hoon Ahn on 2022/02/22.
//

import ReactorKit
import RxFlow
import RxSwift
import RxCocoa
import KeychainSwift
import AuthenticationServices

final class OTPModalReactor : Reactor, Stepper{
    
    var disposeBag : DisposeBag = .init()
    
    var steps: PublishRelay<Step> = .init()
    
    enum Action{
        case viewWillAppear
        case backBtnRequired
        case refreshOTPBtnRequired
        case sendOTPBtnRequired(String)
    }
    enum Mutation{
        case countDownOTP(time:Int)
        case refreshAuthenticationMail
        case sendAuthenticationNumber(access :  String, refresh : String, isAdmin : Bool)
    }
    struct State{
        var time : Int?
        var minute : Int?
        var second : Int?
    }
    let initialState: State
    let provider : ServiceProviderType
    let sub, email : String
    var coundDown = 300

    init(with provider : ServiceProviderType, sub : String,email : String){
        self.initialState = State()
        self.provider = provider
        self.sub = sub
        self.email = email
    }
}
//MARK: - Mutate
extension OTPModalReactor{
    func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .viewWillAppear:
            return fetchCountDown()
        case .backBtnRequired:
            steps.accept(BambooStep.backBtnRequired)
            return .empty()
        case .refreshOTPBtnRequired:
            return postOTPauthenticationMail(sub: sub, email: email)
        case let .sendOTPBtnRequired(number):
            return postSendOTPNumber(sub: sub, number: number)
        }
    }
}
//MARK: - Reduce
extension OTPModalReactor{
    func reduce(state: State, mutation: Mutation) -> State {
        var new = state
        switch mutation{
        case let .countDownOTP(time):
            new.time = time
            new.minute = time/60
            new.second = time%60
        case .refreshAuthenticationMail:
            new.time = 300
        case let .sendAuthenticationNumber(access, refresh, isAdmin):
            KeychainSwift().set(access , forKey: "accessToken")
            KeychainSwift().set(refresh , forKey: "refresgToken")
            UserDefaults.standard.set(isAdmin, forKey: "isAdmin")
            UserDefaults.standard.set(true, forKey: "LoginStatus")
            print(isAdmin)
            steps.accept(BambooStep.LoginIsRequired)
        }
        return new
    }
}

//MARK: - Method
private extension OTPModalReactor{
    private func fetchCountDown() -> Observable<Mutation>{
        return Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .map { self.coundDown - $0 }
            .take(coundDown + 1)
            .map{ timePassed in
                Mutation.countDownOTP(time: timePassed)
            }
    }
}

//MARK: - Post
private extension OTPModalReactor{
    private func postOTPauthenticationMail(sub : String, email : String) -> Observable<Mutation>{
        let request = AuthenticationMailRequest(email: email)
        return self.provider.loginService.postAuthenticationMail(sub: sub, authenticationMailRequest: request)
            .map{ Mutation.refreshAuthenticationMail}
    }
    private func postSendOTPNumber(sub : String, number : String) -> Observable<Mutation>{
        let request = AuthenticationNumberRequest(authenticationNumber: number)
        return self.provider.loginService.postAuthenticationNumber(sub: sub, authenticationNumberRequest: request)
            .map{ Mutation.sendAuthenticationNumber(access: $0.data.access ?? "", refresh: $0.data.refresh ?? "", isAdmin: $0.data.isAdmin ?? Bool())}
    }
}