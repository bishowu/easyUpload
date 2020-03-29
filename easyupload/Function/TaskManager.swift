//
//  TaskManager.swift
//  easyupload
//
//  Created by Cecilia on 2020/3/28.
//  Copyright © 2020 Cecilia. All rights reserved.
//
import Photos

protocol TaskChangeObserver {
    func onChanged(taskId: String, progress: Double?, status: TaskManager.TaskStatus)
}

class TaskManager {
    
    enum TaskStatus: String {
        case pending
        case running
        case fail
        case success
    }
    
    public static let shared = TaskManager()
    private var isRunning = false
    private var stopAllTasks = false
    private var uploadTasks = [UploadTask]()
    private var observer: TaskChangeObserver? = nil
    private var runningTasks = [UploadTask]()
    
    var uploadItems: [UploadItem] {
        didSet {
            for m in self.uploadItems {
                let task = UploadTask(item: m)
                self.uploadTasks.append(task)
                self.saveTask(task)
            }
        }
    }
    
    private var nextTask: UploadTask? {
        get {
            let tasks = self.uploadTasks.filter({ $0.status == .pending })
            return tasks.count > 0 ? tasks[0] : nil
        }
        set {}
    }
    
    private func progress(taskId: String?, percentage: Double) {
        
        guard let taskId = taskId else {
            print("Error: progress(): No taskId")
            return
        }
        
        // Update task status
        for i in 0..<self.uploadTasks.count {
            if self.uploadTasks[i].id == taskId {
                self.uploadTasks[i].status = .running
                self.uploadTasks[i].percentage = percentage
                break
            }
        }
        
        self.observer?.onChanged(taskId: taskId, progress: percentage, status: .running)
    }
    
    private func fail(taskId: String?, error: Error) {
        
        guard let taskId = taskId else {
            print("Error: fail(): No taskId")
            return
        }
        
        completed(taskId: taskId, status: .fail)
    }
    
    private func success(taskId: String?) {
        guard let taskId = taskId else {
            print("Error: success(): No taskId")
            return
        }
        
        completed(taskId: taskId, status: .success)
    }
    
    func completed(taskId: String, status: TaskStatus) {
        self.isRunning = false
        
        // Update task status
        for i in 0..<self.uploadTasks.count {
            if self.uploadTasks[i].id == taskId {
                self.uploadTasks[i].status = status
                self.saveTask(self.uploadTasks[i])
                break
            }
        }
        
        self.observer?.onChanged(taskId: taskId, progress: nil, status: status)
        
        if !self.stopAllTasks {
            run()
        }
    }
    
    init() {
        uploadItems = []
        loadOldTasks()
        run()
    }
    
    func loadOldTasks() {
        if let arr = UserDefaults.standard.value(forKey: "UploadTasks") as? [String] {
            for key in arr {
                if let t = UserDefaults.standard.value(forKey: key) as? [String : String] {
                    
                    if let taskId = t["id"] as? String, let st = t["status"] as? String, let devId = t["devId"] as? String, let dest = t["dest"] as? String, let assetId = t["assetId"] as? String {
                        
                        let status: TaskManager.TaskStatus = TaskManager.TaskStatus.init(rawValue: st) ?? .pending
                    
                        self.uploadTasks.append(UploadTask(id: taskId, status: status, item: UploadItem(devId: devId, dest: dest, assetId: assetId)))
                    }
                }
            }
        }
    }
    
    func saveTask(_ task: UploadTask) {
        UserDefaults.standard.set(task.toStringDictionary(), forKey: task.id)
        
        var taskIds: [String] = []
        taskIds.append(task.id)
        
        if let arr = UserDefaults.standard.value(forKey: "UploadTasks") as? [String] {
            taskIds.append(contentsOf: arr)
        }
        UserDefaults.standard.set(taskIds, forKey: "UploadTasks")
    }
    
    func stop() {
        self.stopAllTasks = true
    }
    
    func check() -> Bool {
        // Check environments and conditions
        return true
    }
    
    func run() {
        
        self.stopAllTasks = false
        
        guard isRunning == false else {
            return
        }
        
        guard check() else {
            return
        }
        
        guard let task = self.nextTask else {
            return
        }
        
        upload(task, completionHandler: self.completed(taskId:status:))
    }
    
    func upload(_ task: UploadTask, completionHandler: @escaping (String, TaskStatus)->()) {
        
        self.isRunning = true
  
        task.item.getFileUrl() { url in
            let tusUpload = TUSUpload(task.item)
                
            if let _ = tusUpload.tusUpload {
                tusUpload.uuid = task.id
                tusUpload.progress = self.progress
                tusUpload.fail = self.fail
                tusUpload.success = self.success
                
                task.tusUpload = tusUpload
                self.runningTasks.append(task)
                
            } else {
                // Error: Failed to initialize the tus upload
                completionHandler(task.id, .fail)
            }
        }
    }
    
    func getAllTasks() -> [UploadTask] {
        return self.uploadTasks
    }
    
    func removeAllTasks() {
        self.stop()
        self.uploadTasks.removeAll()
        
        // Clear all UserDefaults
        if let arr = UserDefaults.standard.value(forKey: "UploadTasks") as? [String] {
            for key in arr {
                UserDefaults.standard.removeObject(forKey: key)
            }
            UserDefaults.standard.removeObject(forKey: "UploadTasks")
        }
    }
    
    func setTaskChangeObserver(_ observer: TaskChangeObserver) {
        self.observer = observer
    }
}
