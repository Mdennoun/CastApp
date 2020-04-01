//
//  HomeViewController.swift
//  cast
//
//  Created by DENNOUN Mohamed on 10/03/2020.
//  Copyright © 2020 DENNOUN Mohamed. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import ReplayKit
import WebKit
import AVKit
import Photos
import YTLiveStreaming

class HomeViewController: UIViewController, RPPreviewViewControllerDelegate, WKNavigationDelegate {

    
    @IBOutlet weak var CameraImage: UIImageView!
    @IBOutlet weak var RecordAllScnBTN: UIButton!
    @IBOutlet weak var RecordingBTN: UIButton!
    @IBOutlet weak var CameraBTN: UIButton!
    

    let input = YTLiveStreaming()
    let controller = RPBroadcastController()
    var cameraView1 = UIView(frame: CGRect(x: 0, y: 100, width: 100, height: 100))
    var cameraView : UIView?
    var cameraFrame: CGRect!
    var cameraOrigImage = UIImage(named: "camera")
    var previewView : UIView!
    var boxView:UIView!
    var cameraIsUsed = false
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCaptureStillImageOutput()
    var movieOutput = AVCaptureMovieFileOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    var isRecording = false
    var finalPath: String?
    var latestVideoAssetsFetched: PHFetchResult<PHAsset>? = nil
    
    


    //Camera Capture requiered properties
    var videoDataOutput: AVCaptureVideoDataOutput!
    var videoDataOutputQueue: DispatchQueue!
    var captureDevice : AVCaptureDevice!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Home"
        //cameraFrame = CGRect(x: 0, y: 0, width: 100, height: 200)
        
         previewView = UIView(frame: CGRect(x: 0,
                                           y: 50,
                                           width: 100,
                                           height: 200))
        previewView.contentMode = UIView.ContentMode.scaleAspectFit
        boxView = UIView(frame:  CGRect(x: 0,
        y: 50,
        width: 100,
        height: 200))
        boxView.tag = 1415
        previewView.tag = 1416
        
        view.addSubview(previewView)
        view.addSubview(boxView)
        
        UIScreen.main.addObserver(self, forKeyPath: "captured", options: .new, context: nil)
        var isCaptured = UIScreen.main.isCaptured
        if isCaptured {
            print("yes")
        } else {
            print("no")
        }
        

        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "captured") {
            let isCaptured = UIScreen.main.isCaptured
            print("rze")
            print(isCaptured)
            if (isCaptured) {
                processStartFrontVideo()
            } else {
                processStopFrontVideo()
                
                DispatchQueue.main.async {
                    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                      let documentsDirectory = paths[0] as String

                    let outputFileURL = URL(fileURLWithPath: documentsDirectory + "/Replays/output.mp4")
                      print("file")
                      print(outputFileURL)
                    self.latestVideoAssetsFetched = self.fetchLatestVideos(forCount: 1)
                    
                
                    self.getUrlFromPHAsset(asset: self.latestVideoAssetsFetched!.firstObject!) { (urlvideo1) in
                            print(urlvideo1?.absoluteString)
                            self.mertgevid(savedVideoUrl: urlvideo1!, newVideoUrl: outputFileURL)
                            
                        }
                        
                        
                    
                }
                
                    
                
            }
        }
        
    }
 func fetchLatestVideos(forCount count: Int?) -> PHFetchResult<PHAsset> {

     // Create fetch options.
     let options = PHFetchOptions()

     // If count limit is specified.
     if let count = count { options.fetchLimit = count }

     // Add sortDescriptor so the lastest photos will be returned.
     let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
     options.sortDescriptors = [sortDescriptor]

     // Fetch the photos.
    return PHAsset.fetchAssets(with: .video, options: options)

 }
    
    func mertgevid (savedVideoUrl: URL, newVideoUrl: URL) {
        let savePathUrl : NSURL = NSURL(fileURLWithPath: NSHomeDirectory() + "/Documents/camRecordedVideo.mp4")
        do { // delete old video
            try FileManager.default.removeItem(at: savePathUrl as URL)
        } catch { print(error.localizedDescription) }

        var mutableVideoComposition : AVMutableVideoComposition = AVMutableVideoComposition()
        var mixComposition : AVMutableComposition = AVMutableComposition()

        let aNewVideoAsset : AVAsset = AVAsset(url: newVideoUrl)
        let asavedVideoAsset : AVAsset = AVAsset(url: savedVideoUrl)

        let aNewVideoTrack : AVAssetTrack = aNewVideoAsset.tracks(withMediaType: AVMediaType.video)[0]
        let aSavedVideoTrack : AVAssetTrack = asavedVideoAsset.tracks(withMediaType: AVMediaType.video)[0]

        let mutableCompositionNewVideoTrack : AVMutableCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)!
        do{
            try mutableCompositionNewVideoTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: aNewVideoAsset.duration), of: aNewVideoTrack, at: CMTime.zero)
        }catch {  print("Mutable Error") }

        let mutableCompositionSavedVideoTrack : AVMutableCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)!
        do{
            try mutableCompositionSavedVideoTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: asavedVideoAsset.duration), of: aSavedVideoTrack , at: CMTime.zero)
        }catch{ print("Mutable Error") }

        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeMaximum(asavedVideoAsset.duration, asavedVideoAsset.duration) )

        let newVideoLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: mutableCompositionNewVideoTrack)
        let newScale : CGAffineTransform = CGAffineTransform.init(scaleX: 0.5, y: 0.9)
        let newMove : CGAffineTransform = CGAffineTransform.init(translationX: 655, y: 150)
        newVideoLayerInstruction.setTransform(newScale.concatenating(newMove), at: CMTime.zero)

        let savedVideoLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: mutableCompositionSavedVideoTrack)
        let savedScale : CGAffineTransform = CGAffineTransform.init(scaleX: 0.6, y: 0.52)
        let savedMove : CGAffineTransform = CGAffineTransform.init(translationX: 0, y: 0)
        savedVideoLayerInstruction.setTransform(savedScale.concatenating(savedMove), at: CMTime.zero)

        mainInstruction.layerInstructions = [newVideoLayerInstruction, savedVideoLayerInstruction]


        mutableVideoComposition.instructions = [mainInstruction]
        mutableVideoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mutableVideoComposition.renderSize = CGSize(width: 1240 , height: 1000)

        finalPath = savePathUrl.absoluteString
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)!
        assetExport.videoComposition = mutableVideoComposition
        assetExport.outputFileType = AVFileType.mp4

        assetExport.outputURL = savePathUrl as URL
        assetExport.shouldOptimizeForNetworkUse = true

        assetExport.exportAsynchronously { () -> Void in
            switch assetExport.status {

            case AVAssetExportSession.Status.completed:
                print("success")
                DispatchQueue.main.async {

                    UISaveVideoAtPathToSavedPhotosAlbum(assetExport.outputURL!.relativePath, self, nil, nil)
                    let player = AVPlayer(url: assetExport.outputURL! as URL)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                }
                
            case  AVAssetExportSession.Status.failed:
                print("failed \(assetExport.error)")
            case AVAssetExportSession.Status.cancelled:
                print("cancelled \(assetExport.error)")
            default:
                print("complete")
               
            }
        }
    }
  
    
    @IBAction func startRecordingAllScn(_ sender: Any) {
        
        isRecording = true
        navigationController?.pushViewController(IntermediateViewController(), animated: true)
        
    }
  
    }
    

extension HomeViewController:AVCaptureFileOutputRecordingDelegate {
    
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if (error != nil) {
            print("Error recording movie: \(error!.localizedDescription)")
        } else {


        }
    }
    





    func processStartFrontVideo(){
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as String
        let filePath : String = "\(documentsDirectory)/Replays/output.mp4"
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: URL(fileURLWithPath: filePath))
          } catch {
              print("file not exist")
          }
        
        

        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: .video, position: .front)
        
           for device in devices.devices {
               if (device as AnyObject).position == AVCaptureDevice.Position.front{


                   do{

                    let input = try AVCaptureDeviceInput(device: device )

                       if captureSession.canAddInput(input){

                           captureSession.addInput(input)
                           sessionOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecType.jpeg]

                           if captureSession.canAddOutput(sessionOutput){

                               captureSession.addOutput(sessionOutput)

                               previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                               previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                               previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                               //cameraView!.layer.addSublayer(previewLayer)

                               //previewLayer.bounds = cameraView!.frame


                           }

                           captureSession.addOutput(movieOutput)

                           captureSession.startRunning()
                        let fileUrl = URL(fileURLWithPath: ReplayFileUtil.filePath("output"))
                       
                        
                        movieOutput.startRecording(to: fileUrl, recordingDelegate: self)

                        print(fileUrl)

                       }

                   }
                   catch{

                       print("Error")
                   }

               }
           }

        
    }
    
    func processStopFrontVideo() {

        
        self.movieOutput.stopRecording()
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as String
        let filePath : String = "\(documentsDirectory)/Replays/output.mp4"
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
                UISaveVideoAtPathToSavedPhotosAlbum(filePath, self, nil, nil)
                
                    }
        }
    
    func getpathScreenRec() -> Array<URL> {
        
        let pathURLs : Array<URL> = []
        let filePath = Bundle.main.path(forResource: "1", ofType: "mp4")
        let videoURL = NSURL(fileURLWithPath: filePath!)
        let avAsset = AVAsset(url: videoURL as URL)
        print(avAsset.allMediaSelections)
        
        return pathURLs
    }
  
 
 
    func merge(arrayVideos:[AVAsset], completion:@escaping (_ exporter: AVAssetExportSession) -> ()) -> Void {

      let mainComposition = AVMutableComposition()
      let compositionVideoTrack = mainComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
      compositionVideoTrack?.preferredTransform = CGAffineTransform(rotationAngle: .pi / 2)

      let soundtrackTrack = mainComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)

        var insertTime = CMTime.zero

      for videoAsset in arrayVideos {
        try! compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: videoAsset.tracks(withMediaType: .video)[0], at: insertTime)
        //try! soundtrackTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: videoAsset.tracks(withMediaType: .audio)[0], at: insertTime)

        insertTime = CMTimeAdd(insertTime, videoAsset.duration)
      }

        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as String

      let outputFileURL = URL(fileURLWithPath: documentsDirectory + "/Replays/merge.mp4")

      let fileManager = FileManager()
       // try? fileManager.removeItem(at: outputFileURL)

      let exporter = AVAssetExportSession(asset: mainComposition, presetName: AVAssetExportPresetHighestQuality)

      exporter?.outputURL = outputFileURL
        print(outputFileURL)
      exporter?.outputFileType = AVFileType.mp4
      exporter?.shouldOptimizeForNetworkUse = true

      exporter?.exportAsynchronously {
        DispatchQueue.main.async {
          completion(exporter!)
        }
      }
    }
    func mergev(arrayVideos:[AVAsset], completion:@escaping (URL?, Error?) -> ()) {

      let mainComposition = AVMutableComposition()
      let compositionVideoTrack = mainComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
      compositionVideoTrack?.preferredTransform = CGAffineTransform(rotationAngle: .pi / 2)

      let soundtrackTrack = mainComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)

        var insertTime = CMTime.zero

      for videoAsset in arrayVideos {
        try! compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(start: .zero, duration: videoAsset.duration), of: videoAsset.tracks(withMediaType: .video)[0], at: insertTime)
        //try! soundtrackTrack?.insertTimeRange(CMTimeRangeMake(start: .zero, duration: videoAsset.duration), of: videoAsset.tracks(withMediaType: .audio)[0], at: insertTime)

        insertTime = CMTimeAdd(insertTime, videoAsset.duration)
      }

      let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as String

      let outputFileURL = URL(fileURLWithPath: documentsDirectory + "merge.mp4")
        print("file")
        print(outputFileURL)
      let fileManager = FileManager()
      try? fileManager.removeItem(at: outputFileURL)

      let exporter = AVAssetExportSession(asset: mainComposition, presetName: AVAssetExportPresetHighestQuality)

      exporter?.outputURL = outputFileURL
      exporter?.outputFileType = AVFileType.mp4
      exporter?.shouldOptimizeForNetworkUse = true

      exporter?.exportAsynchronously {
        if let url = exporter?.outputURL{
            print(url)

            UISaveVideoAtPathToSavedPhotosAlbum(url.absoluteString, self, nil, nil)
            completion(url, nil)
            
        }
        if let error = exporter?.error {
            completion(nil, error)
        }
      }
    }
    
    func getUrlFromPHAsset(asset: PHAsset, callBack: @escaping (_ url: URL?) -> Void)
    {
        asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions(), completionHandler: { (contentEditingInput, dictInfo) in

            if let strURL = (contentEditingInput!.audiovisualAsset as? AVURLAsset)?.url.absoluteString
            {
                print("VIDEO URL: \(strURL)")
                callBack(URL.init(string: strURL))
            }
        })
    }
    
    func mergeVideosFilesWithUrl(savedVideoUrl: URL, newVideoUrl: URL, audioUrl:URL)
    {
       
       

    }
  func mergeVideo() {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0] as String
    
            let fileURLs = getpathScreenRec()
        
      /*  DPVideoMerger().mergeVideos(withFileURLs: fileURLs , completion: {(_ mergedVideoFile: URL?, _ error: Error?) -> Void in
            print(mergedVideoFile)
                if error != nil {
                    let errorMessage = "Could not merge videos: \(error?.localizedDescription ?? "error")"
                    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                    self.present(alert, animated: true) {() -> Void in }
                    return
                }
                let objAVPlayerVC = AVPlayerViewController()
                objAVPlayerVC.player = AVPlayer(url: mergedVideoFile!)
                self.present(objAVPlayerVC, animated: true, completion: {() -> Void in
                    objAVPlayerVC.player?.play()
                })
            })*/
        
        
    }
       
    
}
// AVCaptureVideoDataOutputSampleBufferDelegate protocol and related methods
extension HomeViewController:  AVCaptureVideoDataOutputSampleBufferDelegate{

    func startBroadcast() {
        //1
        RPBroadcastActivityViewController.load { broadcastAVC, error in
            
            //2
            guard error == nil else {
                print("Cannot load Broadcast Activity View Controller.")
                return
            }
            
            //3
            if let broadcastAVC = broadcastAVC {
                broadcastAVC.delegate = self as? RPBroadcastActivityViewControllerDelegate
                self.present(broadcastAVC, animated: true, completion: nil)
            }
        }
    }

    

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // do stuff here
    }


}
