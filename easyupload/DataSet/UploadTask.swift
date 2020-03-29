//
//  UploadTask.swift
//  easyupload
//
//  Created by Cecilia on 2020/3/29.
//  Copyright © 2020 Cecilia. All rights reserved.
//
import Foundation

class UploadTask {
    var id: String
    var status: TaskManager.TaskStatus = .pending
    var percentage: Double = 0
    var item: UploadItem
    var tusUpload: TUSUpload? = nil
    
    init(item: UploadItem) {
        self.id = UUID().uuidString
        self.item = item
    }
    
    init(id: String, status: TaskManager.TaskStatus, item: UploadItem) {
        self.id = id
        self.item = item
        self.status = status
    }

    func toStringDictionary() -> [String : String] {
        let dict: [String : String] = [
            "id": self.id,
            "status": self.status.rawValue,
            "dest": self.item.destPath,
            "assetId": self.item.assetId,
            "devId": self.item.destDeviceId
        ]
        
        return dict
    }
}
