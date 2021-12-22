//
//  ReportReactor.swift
//  bamboo-iOS
//
//  Created by Ji-hoon Ahn on 2021/12/16.
//

import ReactorKit
import RxFlow
import RxCocoa

final class ReportReactor: Reactor , Stepper{
    
    var disposeBag : DisposeBag = .init()
    
    var steps: PublishRelay<Step> = .init()
    
    enum Action{
        case dismissModal
    }
    enum Mutation{
        
    }
    struct State{
        
    }
    
    let initialState: State
    
    init(){
        self.initialState = State()
    }
}

extension ReportReactor{
    func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case.dismissModal:
            steps.accept(BambooStep.dismiss)
            return .empty()
        }
    }
}
