//
//  TWMPickerPhotoController.swift
//  ImageProcessing
//
//  Created by StuTan on 2021/4/27.
//
 
import UIKit
import Foundation
import Photos
import ZLPhotoBrowser

class TWMPickerPhotoController: UIViewController {
    var index: Int = 0
    var assets: [PHAsset] = []
    
    override func viewDidLoad() {
        let previewVC = ZLImagePreviewController(datas: assets, index: index, showSelectBtn: true)
        
        previewVC.doneBlock = { [weak self] (res) in
            guard let `self` = self else { return }
            if res.isEmpty {
                self.assets.removeAll()
                return
            }
            
            if res.count != self.assets.count {
                var p = 0, removeIndex: [Int] = []
                for item in res {
                    var index = 0
                    for i in p..<self.assets.count {
                        if self.assets[i] == item as! PHAsset {
                            index = i
                            break
                        }
                    }
                    
                    if index > p {
                        removeIndex.append(contentsOf: p..<index)
                    }
                    if index < p {
                        removeIndex.append(index)
                    }
                    p = index + 1
                }
                removeIndex.append(contentsOf: p..<self.assets.count)
                
                removeIndex.reversed().forEach { (index) in
                    self.assets.remove(at: index)
                }
            }
        }
        
        previewVC.modalPresentationStyle = .fullScreen
        showDetailViewController(previewVC, sender: nil)
    }
}
