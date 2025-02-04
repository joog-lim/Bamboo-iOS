//
//  MainFlow.swift
//  bamboo-iOS
//
//  Created by Ji-hoon Ahn on 2021/12/06.
//

import UIKit

import RxSwift
import RxFlow

final class MainFlow : Flow{
    enum TabIndex : Int{
        case home = 0
        case rule = 1
        case detail = 2
    }
    var root: Presentable{
        return self.rootViewController
    }

    let rootViewController = UITabBarController().then{
        $0.tabBar.backgroundColor = .white
        $0.tabBar.barTintColor = .white
        $0.tabBar.barStyle = .black
        $0.tabBar.tintColor = .bamBoo_57CC4D
        $0.tabBar.layer.applySketchShadow(color: .bamBoo_57CC4D, alpha: 0.25, x: 1, y: 0, blur: 10, spread: 0)
    }
    
    private let provider: ServiceProviderType
    private let homeFlow : HomeFlow
    private let ruleFlow : RuleFlow
    private let detailFlow : DetailFlow
    
    init(with provider: ServiceProviderType){
        self.provider = provider
        self.homeFlow = .init(stepper: .init(), with: provider)
        self.ruleFlow = .init(stepper: .init(), with: provider)
        self.detailFlow = .init(stepper: .init())
    }
    deinit{
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step.asBambooStep else {return .none}
        switch step{
        case .userMainTabBarIsRequired:
            return coordinateToMainTabBar()
        default:
            return .none
        }
    }
    private func coordinateToMainTabBar() -> FlowContributors{
        Flows.use(
            homeFlow,ruleFlow,detailFlow,
            when: .created
        ){ [unowned self] (root1 : UINavigationController,
                                    root2 : UINavigationController,
                                    root3 : UINavigationController)  in
            
            let homeImage : UIImage? = UIImage(named: "BAMBOO_Home")
            let ruleImage : UIImage? = UIImage(named: "BAMBOO_Rule")
            let detailImage : UIImage? = UIImage(named: "BAMBOO_Detail")
            
            let homeItem : UITabBarItem = .init(title: "홈", image: homeImage, selectedImage: nil)
            let ruleItem : UITabBarItem = .init(title: "규칙", image: ruleImage, selectedImage: nil)
            let detailItem : UITabBarItem = .init(title: "더보기", image: detailImage, selectedImage: nil)
            
            [root1,root2,root3].forEach{$0.navigationCustomBar()}
            
            root1.tabBarItem = homeItem
            root2.tabBarItem = ruleItem
            root3.tabBarItem = detailItem
            
            self.rootViewController.setViewControllers([root1,root2,root3], animated: true)
        }
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: homeFlow,withNextStepper: homeFlow.stepper),
            .contribute(withNextPresentable: ruleFlow,withNextStepper: ruleFlow.stepper),
            .contribute(withNextPresentable: detailFlow,withNextStepper: detailFlow.stepper)
        ])
    }
}
