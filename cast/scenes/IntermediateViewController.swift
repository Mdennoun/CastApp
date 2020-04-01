//
//  IntermediateViewController.swift
//  cast
//
//  Created by DENNOUN Mohamed on 11/03/2020.
//  Copyright © 2020 DENNOUN Mohamed. All rights reserved.
//

import UIKit
import ReplayKit

class IntermediateViewController: UIViewController, RPPreviewViewControllerDelegate {

    
    var cameraView: UIView?
    var cameraFrame: CGRect!
    @IBOutlet weak var broadcastPickerView: UIView?
    
    let recordBtnFrame = CGRect(x: 10, y: 50, width: 100, height: 100)
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 12.0, *) {
                var broadCastPicker : RPSystemBroadcastPickerView?
                broadCastPicker = RPSystemBroadcastPickerView(frame:recordBtnFrame )
                broadCastPicker?.tag = 1415
         
         
         
         let pickerView = RPSystemBroadcastPickerView(frame: CGRect(x: 0,y: 0,width: view.bounds.width,height: 80))
            pickerView.preferredExtension = "com.example.cast.BExtensionUpload"
         
         // Theme the picker view to match the white that we want.
         if let button = pickerView.subviews.first as? UIButton {
             button.sendActions(for: UIControl.Event.allTouchEvents)
             button.imageView?.tintColor = UIColor.white
         }
            //self.view.addSubview(pickerView)
            broadcastPickerView = pickerView
            print(pickerView.showsMicrophoneButton)
            print(pickerView.subviews.count) 
            navigationController?.popToRootViewController(animated: false)
               
              
            } else {
                // Fallback on earlier versions
            }

    }
    



}
