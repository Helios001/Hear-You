//
//  Downloader.swift
//  BaseKit
//
//  Created by 董亚珣 on 16/4/1.
//  Copyright © 2016年 snow. All rights reserved.
//

import Foundation
import UIKit

class Downloader: NSObject {
    
    static let sharedDownloader = Downloader()
    
    lazy var session: NSURLSession = {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        return session
    }()
    
    struct ProgressReporter {
        
        struct Task {
            let downloadTask: NSURLSessionDataTask
            
            typealias FinishedAction = NSData -> Void
            let finishedAction: FinishedAction
            
            let progress = NSProgress()
            let tempData = NSMutableData()
            let imageTransform: (UIImage -> UIImage)?
        }
        let tasks: [Task]
        var finishedTasksCount = 0
        
        typealias ReportProgress = (progress: Double, image: UIImage?) -> Void
        let reportProgress: ReportProgress?
        
        init(tasks: [Task], reportProgress: ReportProgress?) {
            self.tasks = tasks
            self.reportProgress = reportProgress
        }
        
        var totalProgress: Double {
            
            let completedUnitCount = tasks.map({ $0.progress.completedUnitCount }).reduce(0, combine: +)
            let totalUnitCount = tasks.map({ $0.progress.totalUnitCount }).reduce(0, combine: +)
            
            return Double(completedUnitCount) / Double(totalUnitCount)
        }
    }
    
    var progressReporters = [ProgressReporter]()
    
    
    class func downloadDataFromURL(URL: NSURL, reportProgress: ProgressReporter.ReportProgress?, finishedAction: ProgressReporter.Task.FinishedAction) {
        
        let downloadTask = sharedDownloader.session.dataTaskWithURL(URL)
        let task = ProgressReporter.Task(downloadTask: downloadTask, finishedAction: finishedAction, imageTransform: nil)
        
        let progressReporter = ProgressReporter(tasks: [task], reportProgress: reportProgress)
        sharedDownloader.progressReporters.append(progressReporter)
        
        downloadTask.resume()
    }

}

extension Downloader: NSURLSessionDataDelegate {
    
    private func reportProgressAssociatedWithDownloadTask(downloadTask: NSURLSessionDataTask, totalBytes: Int64) {
        
        for progressReporter in progressReporters {
            
            for i in 0..<progressReporter.tasks.count {
                
                if downloadTask == progressReporter.tasks[i].downloadTask {
                    
                    progressReporter.tasks[i].progress.totalUnitCount = totalBytes
                    
                    progressReporter.reportProgress?(progress: progressReporter.totalProgress, image: nil)
                    
                    return
                }
            }
        }
    }
    
    private func reportProgressAssociatedWithDownloadTask(downloadTask: NSURLSessionDataTask, didReceiveData data: NSData) -> Bool {
        
        for progressReporter in progressReporters {
            
            for i in 0..<progressReporter.tasks.count {
                
                if downloadTask == progressReporter.tasks[i].downloadTask {
                    
                    let didReceiveDataBytes = Int64(data.length)
                    progressReporter.tasks[i].progress.completedUnitCount += didReceiveDataBytes
                    progressReporter.tasks[i].tempData.appendData(data)
                    
                    let progress = progressReporter.tasks[i].progress
                    let final = progress.completedUnitCount == progress.totalUnitCount
                    progressReporter.reportProgress?(progress: progressReporter.totalProgress, image: nil)
                    
                    return final
                }
            }
        }
        
        return false
    }
    
    private func finishDownloadTask(downloadTask: NSURLSessionDataTask) {
        
        for i in 0..<progressReporters.count {
            
            for j in 0..<progressReporters[i].tasks.count {
                
                if downloadTask == progressReporters[i].tasks[j].downloadTask {
                    
                    let finishedAction = progressReporters[i].tasks[j].finishedAction
                    let data = progressReporters[i].tasks[j].tempData
                    finishedAction(data)
                    
                    progressReporters[i].finishedTasksCount += 1
                    
                    // 若任务都已完成，移除此 progressReporter
                    if progressReporters[i].finishedTasksCount == progressReporters[i].tasks.count {
                        progressReporters.removeAtIndex(i)
                    }
                    
                    return
                }
            }
        }
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        println("Downloader begin, expectedContentLength:\(response.expectedContentLength)")
        reportProgressAssociatedWithDownloadTask(dataTask, totalBytes: response.expectedContentLength)
        completionHandler(.Allow)
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        println("Downloader data.length: \(data.length)")
        
        let finish = reportProgressAssociatedWithDownloadTask(dataTask, didReceiveData: data)
        
        if finish {
            println("Downloader finish")
            
            finishDownloadTask(dataTask)
        }
    }
}
