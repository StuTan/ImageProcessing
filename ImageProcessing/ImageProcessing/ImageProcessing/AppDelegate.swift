//
//  AppDelegate.swift
//  ImageProcessing
//
//  Created by StuTan on 2021/4/27.
//

import UIKit


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
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootNav = UINavigationController(rootViewController: TWMShowPhotoController())
        window?.rootViewController = rootNav
        window?.makeKeyAndVisible()

        return true
    }
  

}

