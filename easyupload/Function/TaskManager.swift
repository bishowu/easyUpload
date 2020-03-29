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
                self.uploadTasks.append(UploadTask(item: m))
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
        print("cctest =====> percentage = \(percentage)")
        
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
        print("cctest ======> fail = \(error)")
        
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
    }
    
    func stop() {
        self.stopAllTasks = true
    }
    
    func check() -> Bool {
        // Check environments and conditions
        return true
    }
    
    func run() {
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
        self.observer?.onChanged(taskId: task.id, progress: nil, status: .running)
        
//        print("cctest ===> \(task.asset.localIdentifier): \(task.asset.value(forKey: "filename") ?? "NA")")
        
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
    
        // test
//        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(3)) {
//            completionHandler(task.id, .success)
//        }
    }
    
    func getAllTasks() -> [UploadTask] {
        return self.uploadTasks
    }
    
    func removeAllTasks() {
        self.stop()
        self.uploadTasks.removeAll()
    }
    
    func setTaskChangeObserver(_ observer: TaskChangeObserver) {
        self.observer = observer
    }
}
