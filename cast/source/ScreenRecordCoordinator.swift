//
//  ScreenRecordCoordinator.swift
//  cast
//
//  Created by DENNOUN Mohamed on 13/03/2020.
//  Copyright © 2020 DENNOUN Mohamed. All rights reserved.
//
import UIKit
import Foundation

class ScreenRecordCoordinator: NSObject {
    
    let viewOverlay = WindowUtil()
    let screenRecorder = ScreenRecorder()
    var recordCompleted:((Error?) ->Void)?
    
    override init()
    {
        super.init()
        
        viewOverlay.onStopClick = {
            self.stopRecording()
        }
        
        
    }
    
    func startRecording(withFileName fileName: String, recordingHandler: @escaping (Error?) -> Void,onCompletion: @escaping (Error?)->Void)
    {
        self.viewOverlay.show()
        screenRecorder.startRecording(withFileName: fileName) { (error) in
            recordingHandler(error)
            self.recordCompleted = onCompletion
        }
    }
    
    func stopRecording()
    {
        screenRecorder.stopRecording { (error) in
            self.viewOverlay.hide()
            self.recordCompleted?(error)
        }
        
    }
    
    class func listAllReplays() -> Array<URL>
    {
        return ReplayFileUtil.fetchAllReplays()
    }
    
}
