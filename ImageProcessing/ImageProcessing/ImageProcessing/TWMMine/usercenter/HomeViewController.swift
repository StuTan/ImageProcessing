//
//  HomeViewController.swift
//  ImageProcessing
//
//  Created by StuTan on 2021/5/6.
//

import Foundation
import UIKit

var isLogin: Int = 0

// 第一步: 继承自`UserCenterContentProxyViewController`
class HomeViewController: UserCenterContentProxyViewController {
    
    let tableView = UITableView(frame: .zero, style: .plain)
    let names = ["昵称：油醋三椒", "性别：女", "地区：冰岛"]
    let descs = ["昵称：", "性别：", "地区："]
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    } 
    override func viewDidLoad() {
        super.viewDidLoad()

        // 第二步: 设置contentInset属性
        tableView.contentInset = defaultScrollContentInsets(for: .navigationBarAndTabBar)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.separatorStyle = .singleLine
         
        isLogin = UserDefaults.standard.integer(forKey: "IsLogin")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 第三步: 重写父类方法
    override func scrollToTop() {
        tableView.setContentOffset(.zero, animated: false)
    }

}


extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cell";
                
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellID)
        
        cell.textLabel?.text = (isLogin == 0 ? String(descs[indexPath.row]) : String(names[indexPath.row]))
        return cell
    }
    
}


extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
     
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
     
    
}
