//
//  UploadItem.swift
//  easyupload
//
//  Created by Cecilia on 2020/3/29.
//  Copyright © 2020 Cecilia. All rights reserved.
//

import Foundation
import Photos

class UploadItem {
    var fileSize: Int64
    var modifiedTime: CLong
    var assetId: String
    var filename: String
    var destPath: String
//    var destDeviceId: String
    var rename: Bool = true
    var iCloudPhoto: Bool = false
    var asset: PHAsset? {
        get {
            let options = PHFetchOptions()
            let aaa = PHAsset.fetchAssets(withLocalIdentifiers: [self.assetId], options: options)
            let a = aaa.count > 0 ? aaa.firstObject : nil
            
            self.iCloudPhoto = a?.value(forKey: "isCloudPhotoLibraryAsset") as? Bool ?? false
            return a
        }
        
        set {}
    }
    
    var fileUrl: URL? = nil
    
    init(devId: String, dest: String, media: AssetInfoItem, rename: Bool) {
        self.assetId = media.id
        self.fileSize = media.fileSize
        self.modifiedTime = 0 //cctest: media.modificationTime
        self.filename = media.fileName
//        self.fileUrl = url
        self.destPath = dest
        self.rename = rename
    }
    
    init(assetId: String, name: String, url: URL, size: Int64, timestamp: CLong, devId: String, dest: String) {
        self.assetId = assetId
        self.fileSize = size
        self.modifiedTime = timestamp
        self.filename = name
        self.fileUrl = url
        self.destPath = dest
        
        print("cctest ====> upload item size = \(size)")
    }
    
    func getFileUrl(completionHandler: @escaping (URL?)->()) {
        self.asset?.getURL(completionHandler: { (url) in
            self.fileUrl = url
            completionHandler(url)
        })
    }
    
    // Override this function
    func getServerUrl() ->  String {
        // Get XnBay from deviceId
        return XnBayUtil.shared.tusUploadUrl
    }
    
    // Override this function
    func getAccessToken() -> String {
        // Get XnBay from deviceId
        return XnBayUtil.shared.accessToken ?? ""
    }
}
