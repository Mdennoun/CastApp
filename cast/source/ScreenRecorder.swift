//
//  ScreenRecorder.swift
//  cast
//
//  Created by DENNOUN Mohamed on 13/03/2020.
//  Copyright © 2020 DENNOUN Mohamed. All rights reserved.
//

import UIKit
import Foundation
import ReplayKit

class ScreenRecorder : HomeViewController {

        var videoInput:AVAssetWriterInput!

        var assetWriter: AVAssetWriter!
        let viewOverlay = WindowUtil()
        
        //MARK: Screen Recording
        func startRecording(withFileName fileName: String, recordingHandler:@escaping (Error?)-> Void)
        {
            self.processStartFrontVideo()
            if #available(iOS 11.0, *)
            {
                
                let fileURL = URL(fileURLWithPath: ReplayFileUtil.filePath(fileName))
                assetWriter = try! AVAssetWriter(outputURL: fileURL, fileType:
                    AVFileType.mp4)
                let videoOutputSettings: Dictionary<String, Any> = [
                    AVVideoCodecKey : AVVideoCodecType.h264,
                    AVVideoWidthKey : UIScreen.main.bounds.size.width,
                    AVVideoHeightKey : UIScreen.main.bounds.size.height
                ];
                
                videoInput  = AVAssetWriterInput (mediaType: AVMediaType.video, outputSettings: videoOutputSettings)
                videoInput.expectsMediaDataInRealTime = true
                assetWriter.add(videoInput)
                
                RPScreenRecorder.shared().startCapture(handler: { (sample, bufferType, error) in
    //                print(sample,bufferType,error)
                    
                    recordingHandler(error)
                    
                    if CMSampleBufferDataIsReady(sample)
                    {
                        if self.assetWriter.status == AVAssetWriter.Status.unknown
                        {
                            self.assetWriter.startWriting()
                            self.assetWriter.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sample))
                        }
                        
                        if self.assetWriter.status == AVAssetWriter.Status.failed {
                            print("Error occured, status = \(self.assetWriter.status.rawValue), \(self.assetWriter.error!.localizedDescription) \(String(describing: self.assetWriter.error))")
                            return
                        }
                        
                        if (bufferType == .video)
                        {
                            if self.videoInput.isReadyForMoreMediaData
                            {
                                self.videoInput.append(sample)
                            }
                        }
                    }
                    
                }) { (error) in
                    recordingHandler(error)
    //                debugPrint(error)
                }
            } else
            {
                // Fallback on earlier versions
            }
        }
        
        func stopRecording(handler: @escaping (Error?) -> Void)
        {
            self.processStopFrontVideo()
            if #available(iOS 11.0, *)
            {
                RPScreenRecorder.shared().stopCapture
                {    (error) in
                        handler(error)
                    print("here error")
                    print(error)
                        self.assetWriter.finishWriting
                    {
                        
                        print(ReplayFileUtil.fetchAllReplays())
                        
                    }
                }
                // path to documents directory
                let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                if let documentDirectoryPath = documentDirectoryPath {
                let replayDirectoryPath = documentDirectoryPath.appending("/Replays/screenRecord1.mp4")
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: replayDirectoryPath) {
                    UISaveVideoAtPathToSavedPhotosAlbum(replayDirectoryPath, self, nil, nil)
                    
                        }
                
                }
        }
    }
}
