//
//  TWMMineController.swift
//  ImageProcessing
//
//  Created by StuTan on 2021/4/30.
//

import Foundation
import UIKit
import AuthenticationServices

class TWMMineController: UIViewController, ASAuthorizationControllerDelegate {
    
    @IBOutlet weak var mineTableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    let names = ["昵称：油醋三椒", "性别：女", "地区：冰岛"]
    let descs = ["油醋三椒", "女", "冰岛"]
    var countNames = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewClick))
        imageView?.addGestureRecognizer(singleTapGesture)
        imageView?.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        
        mineTableView.dataSource = self
        mineTableView.delegate = self
        mineTableView.separatorStyle = .none
 
    }
    
    @objc func imageViewClick() {
        
        OpenShare.weixinAuth("snsapi_userinfo", success: {_ in
            UIAlertController.showAlert(message: "微信登录成功")
            self.imageView.image = UIImage.init(named: "image2")
            self.countNames = 3
            self.mineTableView.reloadData()
        }, fail: {_,_  in
            UIAlertController.showAlert(message: "微信登录失败")
        })
        
    }
    
    
    
}

extension TWMMineController: UITableViewDelegate, UITableViewDataSource {
    //Section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countNames
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID = "cell";
                
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellID)
        
        cell.textLabel?.text = String(names[indexPath.row] )
//        cell.detailTextLabel?.text = "test\(descs[indexPath.row])"
    
        return cell
    }
    
    
}
