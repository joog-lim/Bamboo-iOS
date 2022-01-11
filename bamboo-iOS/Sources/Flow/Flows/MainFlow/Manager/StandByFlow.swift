//
//  StandByFlow.swift
//  bamboo-iOS
//
//  Created by Ji-hoon Ahn on 2021/12/07.
//

import UIKit
import PanModal

import RxFlow
import RxRelay
import ReactorKit

struct StandByStepper : Stepper{

    let steps: PublishRelay<Step> = .init()
    
    var initialStep: Step{
        return BambooStep.managerStandByIsRequired
    }
}

final class StandByFlow : Flow{
    private let disposeBag: DisposeBag = .init()

    //MARK: - Properties
    var root: Presentable{
        return self.rootViewController
    }
    let stepper: StandByStepper
    let reactor : StandByReactor = .init()
    private let rootViewController = UINavigationController()
    
    //MARK: - Initalizer
    init(stepper : StandByStepper){
        self.stepper = stepper
        
    }
    deinit{
        print("\(type(of: self)): \(#function)")
    }
    //MARK: - Navigation
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step.asBambooStep else {return .none}
        switch step{
        case.managerStandByIsRequired:
            return coordinatorToStandBy()
        case let .alert(titleText, message, idx,index):
            return navigateToAlertScreen(titleText: titleText, message: message, idx: idx, index: index)
        case let .refusalRequired(idx, index):
            return coordinatorToRefusalModalRequired(idx: idx, index: index)
        default:
            return.none
        }
    }
}

private extension StandByFlow{
    func coordinatorToStandBy() -> FlowContributors{
        let vc = StandByViewController(reactor: reactor)
        self.rootViewController.setViewControllers([vc], animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc,withNextStepper: reactor))
    }
    
    func navigateToAlertScreen(titleText : String, message : String, idx : Int, index : Int) -> FlowContributors{
        let alert = UIAlertController(title: titleText, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "수락", style: .default,handler: { _ in
        }))
        alert.addAction(.init(title: "거절", style: .destructive, handler: {_ in
            _ = self.reactor.mutate(action: .alertRefusalTap(idx, index))
        }))
        rootViewController.present(alert, animated: true)
        return .none
    }
    
    func coordinatorToRefusalModalRequired(idx : Int, index :Int) -> FlowContributors{
        let reactor = RefusalModalReactor()
        let vc = RefusalModal(reactor: reactor)
        vc.modalPresentationStyle = .custom
        vc.modalPresentationCapturesStatusBarAppearance = true
        vc.transitioningDelegate = PanModalPresentationDelegate.default
        rootViewController.present(vc, animated: true, completion: nil)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: reactor))
    }
}
