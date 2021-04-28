//
//  TWMSavePhotoMethod.swift
//  ImageProcessing
//
//  Created by StuTan on 2021/4/28.
//

import Foundation
import UIKit

class TWMSavePhotoMethod {
    
    func saveImage(image: UIImage) -> String {

        let imageData = NSData(data: image.pngData()!)
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,  FileManager.SearchPathDomainMask.userDomainMask, true)
        let docs = paths[0] as NSString
        let uuid = NSUUID().uuidString + ".png"
        let fullPath = docs.appendingPathComponent(uuid)
        _ = imageData.write(toFile: fullPath, atomically: true)
        
        return uuid
   }
    
    func getImage(imageNames: [String]) -> [UIImage] {

        var savedImages: [UIImage] = [UIImage]()

        for imageName in imageNames {
            if let imagePath = getFilePath(fileName: imageName) {
                savedImages.append(UIImage(contentsOfFile: imagePath)!)
            }
       }
        
       return savedImages
    }
    
    func getFilePath(fileName: String) -> String? {

        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        var filePath: String?
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if paths.count > 0 {
            let dirPath = paths[0] as NSString
            filePath = dirPath.appendingPathComponent(fileName)
        } else {
            filePath = nil
        }
        
        return filePath
    }
    
}
