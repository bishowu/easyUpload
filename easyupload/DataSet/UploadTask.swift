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
}
