//
//  QRViewController.swift
//  FinalProject
//
//  Created by Sergio Acosta on 11/07/16.
//  Copyright © 2016 Sergio Acosta. All rights reserved.
//

import UIKit
import AVFoundation

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var session: AVCaptureSession?
    var layer: AVCaptureVideoPreviewLayer?
    var frame: UIView?
    var urls: String?
    
    override func viewWillAppear(animated: Bool) {
        session?.startRunning()
        frame?.frame = CGRectZero
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "QR"
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: device)
            session = AVCaptureSession()
            session?.addInput(input)
            
            let metaData = AVCaptureMetadataOutput()
            session?.addOutput(metaData)
            metaData.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metaData.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            layer = AVCaptureVideoPreviewLayer(session: session)
            layer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            layer!.frame = view.layer.bounds
            view.layer.addSublayer(layer!)
            frame = UIView()
            frame!.layer.borderWidth = 3
            frame!.layer.borderColor = UIColor.redColor().CGColor
            view.addSubview(frame!)
            session?.startRunning()
        } catch let error as NSError {
            print(error.description)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        frame!.frame = CGRectZero
        if metadataObjects == nil || metadataObjects.count == 0 {
            return
        }
        let objMetadata = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if objMetadata.type == AVMetadataObjectTypeQRCode {
            //let objBorders = layer?.transformedMetadataObjectForMetadataObject(objMetadata) as! AVMetadataMachineReadableCodeObject
            //layer?.frame = objBorders.bounds
            if objMetadata.stringValue != nil {
                self.urls = objMetadata.stringValue
                let navc = self.navigationController
                navc?.performSegueWithIdentifier("webSegue", sender: self)
            }
        }
    }
}
