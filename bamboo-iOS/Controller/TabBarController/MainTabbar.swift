//
//  MainTabbar.swift
//  bamboo-iOS
//
//  Created by Ji-hoon Ahn on 2021/09/22.
//

import UIKit



class MainTabbar : UIViewController{
    //MARK: - Properties
    
    private lazy var mainTabBarView = CustomTabbar()
    
    private lazy var mainViewController = MainViewController()
    private lazy var ruleViewController = RuleViewController()
    private lazy var detailViewController = DetailViewController()
    
    private lazy var viewControllerBoxView = UIView()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        navigationSetting()
        
    }
    //MARK: - Selectors
   
    
    @objc func home(sender:UIButton){
        self.addChild(mainViewController)
        mainViewController.view.frame = viewControllerBoxView.frame
        viewControllerBoxView.addSubview(mainViewController.view)
        removeRule()
        removeDetail()
        mainTabBarView.homeBtn.tintColor = .bamBoo_57CC4D
    }
    @objc func rule(sender:UIButton){
        self.addChild(ruleViewController)
        ruleViewController.view.frame = viewControllerBoxView.frame
        viewControllerBoxView.addSubview(ruleViewController.view)
        removeMain()
        removeDetail()
        mainTabBarView.ruleBtn.tintColor = .bamBoo_57CC4D
    }
    @objc func detail(sender:UIButton){
        self.addChild(detailViewController)
        detailViewController.view.frame = viewControllerBoxView.frame
        viewControllerBoxView.addSubview(detailViewController.view)
        removeMain()
        removeRule()
        mainTabBarView.detailsBtn.tintColor = .bamBoo_57CC4D
    }
    //MARK: - Remove Page
    private func removeMain(){
        mainViewController.removeFromParent()
        mainViewController.view.removeFromSuperview()
        mainTabBarView.homeBtn.tintColor = .lightGray
    }
    private func removeRule(){
        ruleViewController.removeFromParent()
        ruleViewController.view.removeFromSuperview()
        mainTabBarView.ruleBtn.tintColor = .lightGray
    }
    private func removeDetail(){
        mainTabBarView.detailsBtn.tintColor = .lightGray
        detailViewController.removeFromParent()
        detailViewController.view.removeFromSuperview()
    }
    
    //MARK: - Helper
    private func configureUI(){
        self.view.addSubview(mainTabBarView)
        self.view.addSubview(viewControllerBoxView)
        mainTabBarView.homeBtn.addTarget(self, action: #selector(home(sender:)), for: .touchUpInside)
        mainTabBarView.ruleBtn.addTarget(self, action: #selector(rule(sender:)), for: .touchUpInside)
        mainTabBarView.detailsBtn.addTarget(self, action: #selector(detail(sender:)), for: .touchUpInside)
        viewControllerBoxView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(mainTabBarView.snp.top)
        }
        mainTabBarView.snp.makeConstraints {
            $0.height.equalTo(view.frame.height/9.9024)
            $0.left.right.bottom.equalToSuperview()
        }
        self.addChild(mainViewController)
        mainViewController.view.frame = viewControllerBoxView.frame
        viewControllerBoxView.addSubview(mainViewController.view)
    }
    
    //MARK: - Navigation Setting
    func navigationSetting(){
        navigationController?.navigationCustomBar()
        navigationItem.hidesBackButton = true
        navigationItem.applyImageNavigation()
    }
}
