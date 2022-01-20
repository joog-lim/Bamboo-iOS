//
//  AppDelegate.swift
//  bamboo-iOS
//
//  Created by Ji-hoon Ahn on 2021/09/06.
//

import UIKit
import GoogleSignIn

import RxAppState
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetWorkStatus.shared.StartMonitoring()
        automaticLogin()
        keyboardSetting()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled : Bool
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled{
            return true
        }
        return false
    }
    
    //Keyboard 자동 UI 조정
    private func keyboardSetting(){
//        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.enableAutoToolbar = false
//        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }

    //자동 로그인
    private func automaticLogin(){
        let defaults = UserDefaults.standard
        GIDSignIn.sharedInstance.restorePreviousSignIn { user , error in
            if error != nil || user == nil{
                print("No user")
                defaults.removeObject(forKey: "LoginStatus")
                //Show the app's signed out state
            }else{
                print("Login")
                defaults.set(true, forKey: "LoginStatus")
                //show the app's Signed- in state
            }
        }
    }
}

