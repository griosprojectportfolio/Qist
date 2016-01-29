//
//  ScannerController.swift
//  Qist
//
//  Created by GrepRuby3 on 16/09/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import AVFoundation
import AFNetworking
import MagicalRecord

class ScannerController : BaseController , AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var messageLabel:UILabel!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    // MARK: -  Supported barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    
    
    // MARK: -  Current view related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SCANNER"
        self.setupScannerView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup befour appear the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after appear the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: -  Segue methods for Page transition.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ScanProduct" {
            segue.destinationViewController as! ScanProductController
        }
    }
    
    
    // MARK: -  QR Code Scanner setup and their Delegate Methods
    func setupScannerView() {
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AnyObject!
        do {
            //input = try AVCaptureDeviceInput.deviceInputWithDevice(captureDevice)
           input = try AVCaptureDeviceInput(device: captureDevice) as AVCaptureDeviceInput
            
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            print("\(error?.localizedDescription)")
            messageLabel.text = "Camera not supported in your Device."
            return
        }
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        captureSession?.addInput(input as! AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = supportedBarCodes
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession?.startRunning()
        
        // Move the message label to the top view
        view.bringSubviewToFront(messageLabel)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.appBackgroundColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 5
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            messageLabel.text = "NO QIST QR DETECTED"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.filter({ $0 == metadataObj.type }).count > 0 {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                getScannedProduct(metadataObj.stringValue)
            }
        }
    }
    
    
    // MARK: -  Navigate to Scanned Product Page
    func getScannedProduct(decodedURL: String) {
        print(decodedURL)
//        let aParams : NSDictionary = ["access_token":self.auth_token,"product_code":decodedURL]
//        self.sharedApi.baseRequestWithHTTPMethod("GET", URLString: "wishlist", parameters: aParams, successBlock: { (task : AFHTTPRequestOperation?, responseObject : AnyObject?) -> () in
//            
//            self.stopLoadingIndicatorView()
//            let dictResponse : NSDictionary = responseObject as! NSDictionary
//            print(dictResponse)
//            },
//            failureBlock : { (task : AFHTTPRequestOperation?, error: NSError?) -> () in
//                self.stopLoadingIndicatorView()
//                if task!.responseData != nil {
//                    self.showErrorMessageOnApiFailure(task!.responseData!, title: "WISHLISTS!")
//                }else{
//                    self.showErrorPopupWith_title_message("", strMessage:"Server request timed out.")
//                }
//        })

        if decodedURL == "http://www.qist.co.nz" {
            self.stopScanningQRs()
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.activityIndicator.stopActivityIndicator(self)
                self.performSegueWithIdentifier("ScanProduct", sender: self)
            }
        }else{
            messageLabel.text = "NO QIST QR DETECTED"
        }
    }
    
    // MARK: -  Common methods of Scanner page.
    func stopScanningQRs(){
        activityIndicator = ActivityIndicatorView(frame: self.view.frame)
        activityIndicator.startActivityIndicator(self)
        // Start video capture.
        captureSession?.stopRunning()
        captureSession = nil
        videoPreviewLayer?.removeFromSuperlayer()
        qrCodeFrameView?.removeFromSuperview()
    }
    
    
}
