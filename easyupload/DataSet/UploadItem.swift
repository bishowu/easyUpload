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
    var fileSize: Int64 = 0
    var modifiedTime: CLong = 0
    var assetId: String
    var filename: String = ""
    var destPath: String = ""
    var destDeviceId: String = ""
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
        self.modifiedTime = media.modifyTime
        self.filename = media.fileName
        self.destPath = dest
        self.destDeviceId = devId
        self.rename = rename
    }
    
    init(devId: String, dest: String, assetId: String) {
        self.assetId = assetId
        self.destPath = dest
        self.destDeviceId = devId
        self.rename = true // Get current backup settings
        
        if let pojo = self.asset {
            self.filename = pojo.value(forKey: "filename") as! String
            let modificationDate = pojo.value(forKey: "modificationDate") as! Date
            self.modifiedTime = CLong(modificationDate.timeIntervalSince1970)
            self.fileSize = PHAssetResource.assetResources(for: pojo).first?.value(forKey: "fileSize") as? Int64 ?? 0
        }
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
