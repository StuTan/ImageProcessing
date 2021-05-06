//
//  AppDelegate.swift
//  ImageProcessing
//
//  Created by StuTan on 2021/4/27.
//

import UIKit
//import WechatKit


// MARK: - 定义一些常量
let kScreenW  = UIScreen.main.bounds.size.width
let kScreenH  = UIScreen.main.bounds.size.height

let isIphoneX: Bool = {
    if #available(iOS 11.0, *) {
        if UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 0 {
            return true
        }
    }
    return false
}()
var imageArray = [UIImage]()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         
        OpenShare.connectQQ(withAppId:"1103194207")
//        OpenShare connectWeiboWithAppKey:"402180334"
        OpenShare.connectWeibo(withAppKey:"402180334")
        OpenShare.connectWeixin(withAppId: "wxd930ea5d5a258f4f", miniAppId: "gh_d43f693ca31f")
        
//        window = UIWindow(frame: UIScreen.main.bounds)
//        let rootNav = UINavigationController(rootViewController: TWMVisionDetectionController())
//        window?.rootViewController = rootNav
//        window?.makeKeyAndVisible()

        return true
    }
     
    /// iOS 9.0 以后请使用这个方法
        /// Please use this (application:openURL:options:)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if OpenShare.handleOpen(url) {
            return true;
        }
            return true;
    }
    

}

