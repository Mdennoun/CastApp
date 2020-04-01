//
//  ReplayFileUtil.swift
//  cast
//
//  Created by DENNOUN Mohamed on 13/03/2020.
//  Copyright © 2020 DENNOUN Mohamed. All rights reserved.
//

import UIKit

class ReplayFileUtil {
    internal class func createReplaysFolder()
        {
            // path to documents directory
            let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            if let documentDirectoryPath = documentDirectoryPath {
                // create the custom folder path
                let replayDirectoryPath = documentDirectoryPath.appending("/Replays")
                let fileManager = FileManager.default
                if !fileManager.fileExists(atPath: replayDirectoryPath) {
                    do {
                        try fileManager.createDirectory(atPath: replayDirectoryPath,
                                                        withIntermediateDirectories: false,
                                                        attributes: nil)
                    } catch {
                        print("Error creating Replays folder in documents dir: \(error)")
                    }
                }
            }
        }
        
        internal class func filePath(_ fileName: String) -> String
        {
            
            createReplaysFolder()
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0] as String
            let filePath : String = "\(documentsDirectory)/Replays/\(fileName).mp4"
            let fileManager = FileManager.default
            
              do {
                  try fileManager.removeItem(at: URL(fileURLWithPath: filePath))
              } catch {
                  print("error")
              }
            return filePath
        }
        
        internal class func fetchAllReplays() -> Array<URL>
        {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let replayPath = documentsDirectory?.appendingPathComponent("/Replays")
            let directoryContents = try! FileManager.default.contentsOfDirectory(at: replayPath!, includingPropertiesForKeys: nil, options: [])
            return directoryContents
        }
        
    }

protocol Overlayable {
        func show()
        func hide()
    }

