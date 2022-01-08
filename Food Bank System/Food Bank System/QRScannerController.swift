//
//  QRScannerController.swift
//  Food Bank System
//
//  Created by Riad El Mahmoudy on 5/30/20.
//  Copyright © 2020 MeetTheNeed. All rights reserved.
//

import AVFoundation
import UIKit

import UIKit
import AVFoundation

class QRScannerController: UIViewController {

    @IBOutlet var messageLabel1:UILabel!
    @IBOutlet var titleView: UINavigationBar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    /*@IBAction func closeCamera(sender: UIButton){
           //TODO: close camera view
       }*/
 
    var id:String = "nil";
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // /!\ Attributes /!\
         //Display
       
         //QR detection from AVF
         var captureSession = AVCaptureSession()
         var videoPreviewLayer: AVCaptureVideoPreviewLayer?
         var qrFrame: UIView?
         var deviceOutput: AVCapturePhotoOutput?
         var deviceOutputSettings: AVCapturePhotoSettings?
         
         
         override func viewDidLoad() {
             super.viewDidLoad()
            //get back camera
                //initialize
         
          deviceOutput = AVCapturePhotoOutput()
         deviceOutputSettings = AVCapturePhotoSettings()
             //specify device
             guard let camera = getDevice(position:.back) else{
                 print("Failed to get the camera device")
                 return
             }
             do{
                 //try to access camera
                let deviceInput = try
                     AVCaptureDeviceInput(device: camera ) //force unwrapping will give an error if nil
                captureSession.addInput(deviceInput)
                
                let deviceMetaDataOutput = AVCaptureMetadataOutput();
                captureSession.addOutput(deviceMetaDataOutput)
                       
                        //set self as delegate - delegate processes the output then sends it to a dispatch queue
                deviceMetaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                            //type of metadata we're interested in : QR scanning in this case
                deviceMetaDataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
                
                 
                 
                 //QR box outline element
                qrFrame = UIView();
                 if let qrFrame = qrFrame{
                     qrFrame.layer.borderColor = UIColor.green.cgColor
                     qrFrame.layer.borderWidth = 2
                     view.addSubview(qrFrame)
                    view.bringSubviewToFront(qrFrame)
                 }
                
             }catch let error as NSError{
                 print(error)
                 //nil value if camera cant be accessed
               
             }
             // REGULAR CAMERA INPUT OUTPUT CHECK
            /* //check if our input can be used in the session
             if captureSession?.canAddInput(deviceInput!) == true {
                 //add input to the session aka camera input
                 captureSession?.addInput(deviceInput!)
             }
             deviceOutputSettings?.livePhotoVideoCodecType = .jpeg
             deviceOutput?.capturePhoto(with: deviceOutputSettings!, delegate: self)*/
              
             //QR CODE
             //store output if session allows it
            //DISPLAY VIDEO CAPTURED => preview layer!
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
                view.layer.addSublayer(videoPreviewLayer!)
             
             //start capturing
             captureSession.startRunning()
             
             // make UI elements appear on top of video layer
           
            view.bringSubviewToFront(messageLabel1)
            view.bringSubviewToFront(titleView)
             
             // Do any additional setup after loading the view.
           

         }
         
         //getDevice function : opens camera and chooses which one
         func getDevice(position: AVCaptureDevice.Position)->AVCaptureDevice?{
             let devices: NSArray = AVCaptureDevice.devices() as NSArray;
             for aDevice in devices{
                 let cDevice = aDevice as! AVCaptureDevice
                 if cDevice.position == position{
                     return cDevice
                 }
             }
             return nil
         }
  
         func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
             //no qr code is detected
             if metadataObjects.count == 0 {
                qrFrame?.frame = CGRect.null
                 messageLabel1.text = "Aucun code QR n'est détecté"
                 return
             }
             //if detected: store it
             let metadataQR = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
             //if it's a qr code
             if metadataQR.type == AVMetadataObject.ObjectType.qr {
                
                 let barCode = videoPreviewLayer?.transformedMetadataObject(for: metadataQR)
                 qrFrame?.frame = barCode!.bounds
                 
     //change message to what's encrypted by QR code
                 if metadataQR.stringValue != nil {
                     messageLabel1.text = metadataQR.stringValue
                    id = metadataQR.stringValue!
                    messageLabel1.textColor = UIColor(red:177/255, green: 177/255, blue:72/255 , alpha:1.0)
                    messageLabel1.backgroundColor = UIColor(red:113/255, green: 168/255, blue:152/255 , alpha:0.8)
                    //before popping the screen
                    let delay = 1.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay){
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                       
                        let ProfileController = storyBoard.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
                             ProfileController.modalPresentationStyle = .fullScreen
                        let myID:Int? = Int(self.messageLabel1.text!)
                        if(myID != nil){
                            ProfileController.id = myID ?? 0;
                        }
                            self.present(ProfileController, animated: true, completion: nil)
                    }
                   
                 }
             }
         
         }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       // let vc = segue.destination as! ProfileController
        //let myID:Int? = Int(self.messageLabel1.text!)
        //else {myID = 0}
        //vc.id = myID!;
       // print(myID);
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
   @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
   
    

}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {

}
