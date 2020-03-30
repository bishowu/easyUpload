//
//  TUSUploadUtil.swift
//  easyupload
//
//  Created by Cecilia on 2020/3/29.
//  Copyright © 2020 Cecilia. All rights reserved.
//

import Foundation
import TUSKit

class TUSUpload {
    
    var resumableUpload: TUSResumableUpload? = nil
    var uuid: String?
    var storeKey: String = ""
    var uploadId: String? {
        get {
            if !self.storeKey.isEmpty {
                return UserDefaults.standard.value(forKey: self.storeKey) as? String
            }
            return nil
        }
        
        set {
            if !self.storeKey.isEmpty {
                UserDefaults.standard.set(newValue, forKey: self.storeKey)
            }
        }
    }
    
    var progress: ((String?, Double)->())? = nil
    var fail: ((String?, Error)->())? = nil
    var success: ((String?)->())? = nil
    
    init(_ item: UploadItem) {
        self.resumableUpload = upload(item)
    }
    
    func start() {
        self.resumableUpload?.resume()
    }
    
    func stop() {
        self.resumableUpload?.stop()
    }
    
    // Resumable upload via TUS
    private func upload(_ media: UploadItem) -> TUSResumableUpload? {
        
        let CHUNK_SIZE: Int64 = 1024 * 1024 * 10 // 10MB
        let parameters: [String: String] = [
            "Action": "ACTION_BACKUP",
            "target_dir": media.destPath,
            "upload_size": String(media.fileSize),
            "renamed": (media.rename ? "true" : "false"),
            "modified_time": String(media.modifiedTime),
            "AccessToken": media.getAccessToken()
        ]
        
        var upload: TUSResumableUpload?
        self.storeKey = "\(media.destPath)_\(media.assetId)"
    
        let server = media.getServerUrl()
        guard !server.isEmpty, let serverUrl = URL(string: server) else {
            return nil
        }
        
        guard let resourceURL = media.fileUrl else {
            return nil
        }
 
        let uploadStore = TUSFileUploadStore()
        let session = TUSSession(endpoint: serverUrl, dataStore: uploadStore, allowsCellularAccess: true)
        
        if let id = self.uploadId, let uploadUrl = URL(string: "\(server)\(id)") {
            // Resumable
            upload = session.createUpload(fromFile: resourceURL, retry: 2, headers: nil, metadata: parameters, uploadUrl: uploadUrl)
        } else {
            // NEW
            upload = session.createUpload(fromFile: resourceURL, retry: 2, headers: nil, metadata: parameters)
        }
        
        upload?.setChunkSize(CHUNK_SIZE)
        upload?.progressBlock = { (bytesWritten, bytesTotal) in
        
            // Get uploadId
            if let data = upload?.serialize() {
                if let url = data["uploadUrl"] as? String {
                    let id = url.replacingOccurrences(of: server, with: "")
                    if id != self.uploadId {
                        self.uploadId = id
                    }
                }
            }
            
            let percent = Double(bytesWritten * 100) / Double(bytesTotal)
            self.progress?(self.uuid, percent)
            
        }
        upload?.failureBlock = { error in
            print("Error: tus error = \(error)")
            self.fail?(self.uuid, error)
        }
        upload?.resultBlock = { fileURL in
            self.success?(self.uuid)
        }
        
        upload?.resume()
        return upload
        
    }

}
