//
//  TWMMineController.swift
//  ImageProcessing
//
//  Created by StuTan on 2021/4/30.
//

import Foundation
import UIKit
import AuthenticationServices
private let headerViewHeight: CGFloat = 200.0

class TWMMineController: UIViewController {
    
    // MARK: Properties
    
    /// 标记`scrollView`是否可以滚动
    private var isScrollViewCanScroll = true
    /// 滚动视图
    private let scrollView: UserCenterScrollView = {
        let scrollView = UserCenterScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    /// 头部视图
    private let headerView = UserCenterHeaderView()
    /// 分段按钮视图
    private let segmentedView = UserCenterSegmentedView()
    /// 用于左右滑动切换控制器
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.interPageSpacing: 10.0])
    /// 控制器
    private let viewControllers: [UserCenterContentProxyViewController] = {
        // TODO: 请替换成你项目的子类视图控制器
        return [
            HomeViewController(),
//            WeiboListViewController(),
            AlbumViewController()
        ]
    }()
    
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
        NotificationCenter.default.addObserver(self, selector: #selector(scrollStateNotification(_:)), name: .userCenterScrollState, object: nil)

        view.addSubview(scrollView)
        scrollView.addSubview(headerView)
        scrollView.addSubview(segmentedView)

        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: headerViewHeight).isActive = true
        
        segmentedView.translatesAutoresizingMaskIntoConstraints = false
        segmentedView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        segmentedView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        segmentedView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        addChild(pageViewController)
        scrollView.addSubview(pageViewController.view)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.topAnchor.constraint(equalTo: segmentedView.bottomAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        pageViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        pageViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -40.0).isActive = true
        pageViewController.didMove(toParent: self)
        
        segmentedView.didTappedButtonHandler = {
            [weak self] (button, index) in
            self?.showChildViewController(at: index)
        }
        // 默认显示`相册`页面
        showChildViewController(at: 1)

        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewClick))
        headerView.avatarImageView.addGestureRecognizer(singleTapGesture)
        headerView.avatarImageView.isUserInteractionEnabled = true
        
        headerView.backgroundImageView.image = UIImage(named: "background")
        headerView.avatarImageView.image = UIImage(named: "imageSticker4")
        headerView.usernameLabel.text = "点击登录"
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Public
    
    func showChildViewController(at index: Int) {
        if index >= viewControllers.count || index < 0 {
            return
        }
        var currentIndex = 0
        if let currentVC = pageViewController.viewControllers?.last as? UserCenterContentProxyViewController,
           let idx = viewControllers.firstIndex(of: currentVC) {
            currentIndex = idx
        }
        let toVC = viewControllers[index]
        let direction: UIPageViewController.NavigationDirection = (currentIndex > index) ? .reverse : .forward
        pageViewController.setViewControllers([toVC], direction: direction, animated: true, completion: nil)
    }
    
    @objc private func scrollStateNotification(_ sender: Notification) {
        isScrollViewCanScroll = true
        viewControllers.forEach { $0.isCanContentScroll = false }
    }
    
    @objc func imageViewClick() {
           
       OpenShare.weixinAuth("snsapi_userinfo", success: {_ in
            UIAlertController.showAlert(message: "微信登录成功")
            self.headerView.avatarImageView.image = UIImage(named: "avatar")
            self.headerView.usernameLabel.text = "油醋三椒"
            isLogin = 1
            UserDefaults.standard.set(isLogin, forKey: "IsLogin") //imagePaths
            UserDefaults.standard.synchronize();
            print( UserDefaults.standard.integer(forKey: "IsLogin"))
        
       }, fail: {_,_  in
           UIAlertController.showAlert(message: "微信登录失败")
       })
           
       }

}

// MARK: -

extension TWMMineController: UIPageViewControllerDataSource {
    
    /// 返回当前页面的下一个页面
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewControllers.count == 0 { return nil }
        guard
            let proxyVC = viewController as? UserCenterContentProxyViewController,
            let index = viewControllers.index(of: proxyVC)
        else { return nil }
        if index < viewControllers.count - 1 {
            return viewControllers[index+1]
        }
        return nil
    }
    
    /// 返回当前页面的上一个页面
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewControllers.count == 0 { return nil }
        guard
            let proxyVC = viewController as? UserCenterContentProxyViewController,
            let index = viewControllers.firstIndex(of: proxyVC)
            else { return nil }
        if index > 0 {
            return viewControllers[index-1]
        }
        return nil
    }
    
}

// MARK: -

extension TWMMineController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard
            let currentVC = pageViewController.viewControllers?.last as? UserCenterContentProxyViewController,
            let index = viewControllers.firstIndex(of: currentVC)
        else { return }
        segmentedView.setIndicatorLocation(at: index)
    }
    
}

// MARK: -

extension TWMMineController: UIScrollViewDelegate {
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        // 子控制器也返回顶部
        viewControllers.forEach { $0.scrollToTop() }
        return true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let navigationBarFrame = navigationController?.navigationBar.frame ?? CGRect.zero
        let navigationBarHeight = navigationBarFrame.origin.y + navigationBarFrame.size.height
        let offsetThreshold = headerViewHeight - navigationBarHeight
        
        if scrollView.contentOffset.y >= offsetThreshold {
            scrollView.setContentOffset(CGPoint(x: 0.0, y: offsetThreshold), animated: false)
            isScrollViewCanScroll = false
            viewControllers.forEach { $0.isCanContentScroll = true }
        } else {
            if !isScrollViewCanScroll {
                scrollView.setContentOffset(CGPoint(x: 0.0, y: offsetThreshold), animated: false)
            }
        }
    }
    
}


// MARK: -

/**
 * Swift中必须显式声明遵守`UIGestureRecognizerDelegate`协议
 * 否则不会回调`gestureRecognizer(_:shouldRecognizeSimultaneouslyWith:)`
 */
private class UserCenterScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    /// 允许同时识别多个手势
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
