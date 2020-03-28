//
//  TaskManager.swift
//  easyupload
//
//  Created by Cecilia on 2020/3/28.
//  Copyright © 2020 Cecilia. All rights reserved.
//
import Photos

protocol TaskChangeObserver {
    func onChanged(taskId: String, progress: Float?, status: TaskManager.TaskStatus)
}

class TaskManager {
    
    struct UploadTask {
        var id: String = UUID().uuidString
        var asset: PHAsset
        var status: TaskStatus = .pending
        var filename: String
    }
    
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
    
    var uploadMedias: [AssetInfoItem] {
        didSet {
            for m in self.uploadMedias {
                self.uploadTasks.append(UploadTask(asset: m.phAsset, filename: m.fileName))
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
    
    func progress(task: UploadTask, percentage: Float) {
        print("cctest =====> percentage = \(percentage)")
        self.observer?.onChanged(taskId: task.id, progress: percentage, status: .running)
    }
    
    func completed(task: UploadTask, status: TaskStatus) {
        self.isRunning = false
        
        // Update task status
        for i in 0..<self.uploadTasks.count {
            if self.uploadTasks[i].id == task.id {
                self.uploadTasks[i].status = status
                break
            }
        }
        
        self.observer?.onChanged(taskId: task.id, progress: nil, status: status)
        
        if !self.stopAllTasks {
            run()
        }
    }
    
    init() {
        uploadMedias = []
    }
    
    func stop() {
        self.stopAllTasks = true
    }
    
    func run() {
        guard isRunning == false else {
            return
        }
        
        guard let task = self.nextTask else {
            return
        }
        
        upload(task, completionHandler: self.completed(task:status:))
    }
    
    func upload(_ task: UploadTask, completionHandler: @escaping (UploadTask, TaskStatus)->()) {
        
        self.isRunning = true
        self.observer?.onChanged(taskId: task.id, progress: nil, status: .running)
        
        print("cctest ===> \(task.asset.localIdentifier): \(task.asset.value(forKey: "filename") ?? "NA")")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(3)) {
            completionHandler(task, .success)
        }
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
