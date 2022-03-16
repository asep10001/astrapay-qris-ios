//
//  QRCameraView.swift
//  astrapay
//
//  Created by Gilbert on 22/10/21.
//  Copyright © 2021 Astra Digital Arta. All rights reserved.
//

import UIKit
import AVFoundation
import Lottie


protocol QRCameraViewProtocol: class {
    func didReceiveDataQR(didReceive: Bool, string : String)
    func didCameraAlreadyAuthorized()
    func didCameraPermissionGranted()
    func didCameraPermissionRejected()
}


class QRCameraView: UIView, AVCaptureVideoDataOutputSampleBufferDelegate {

    private var animationView: AnimationView?

    struct VCProperty{
        var typeName = ""
    }
   
    open var borderSize = CGSize(width: 320, height: 320)
    open var aspectScale : CGFloat = 1
    open var borderColor : UIColor = UIColor.blue

    var videoDataOutputQueue: DispatchQueue!
    var previewLayer:AVCaptureVideoPreviewLayer!
    var captureDevice : AVCaptureDevice!
    let session = AVCaptureSession()

    var delegate : QRCameraViewProtocol?

    override func awakeFromNib() {
        self.backgroundColor = .red
        self.setupAVCapture()
        self.setupUI()


    }
    
    
    open func startSession(){
        session.startRunning()
    }
    
    open func stopSession(){
        session.stopRunning()
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                self.delegate?.didCameraAlreadyAuthorized()
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.delegate?.didCameraPermissionGranted()
                    } else {
                        self.delegate?.didCameraPermissionRejected()
                    }
                }
            case .denied: // The user has previously denied access.
                self.delegate?.didCameraPermissionRejected()
                return
            case .restricted: // The user can't grant access due to restrictions.
                return
        }
    }
    
    private func setupAVCapture(){
        session.sessionPreset = AVCaptureSession.Preset.high
        if #available(iOS 10.2, *) {
            //AVCaptureDevice.Position
            let deviceDiscoverySession =
                AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
            guard let device = deviceDiscoverySession.devices.first else {
                print("Failed to get the camera device")
                return
            }
            captureDevice = device
            formatSession()
        } else {
            // Fallback on earlier versions
       }
    }
    
    private func formatSession(){
        var deviceInput: AVCaptureDeviceInput!

        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            guard deviceInput != nil else {
               print("error: can't get device input")
               return
            }

            if self.session.canAddInput(deviceInput){
               self.session.addInput(deviceInput)
            }
          
            var videoDataOutput = AVCaptureMetadataOutput()
           
            if session.canAddOutput(videoDataOutput){
               session.addOutput(videoDataOutput)
            }
            
            self.setupScanQRRect(mediaDataOutput: &videoDataOutput)
            self.setupPreviewLayer()
            self.layer.addSublayer(self.previewLayer)
            session.startRunning()
           
        } catch let error as NSError {
           deviceInput = nil
           print("error: \(error.localizedDescription)")
        }
    }
    
    private func setupScanQRRect( mediaDataOutput: inout AVCaptureMetadataOutput){
        mediaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        mediaDataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        mediaDataOutput.rectOfInterest = UIScreen.main.bounds
    }
    
    private func borderFrame() -> CGRect {
           let borderWidth = borderSize.width * 1
           let borderHeight = borderSize.height * 1
           return CGRect(
            x: self.frame.width/2 - borderWidth/2,
            y:  self.frame.height/2 - borderHeight/2,
               width: borderWidth,
               height: borderHeight
           )
    }
    
    private func setupPreviewLayer(){
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height:self.frame.height)
        self.previewLayer.backgroundColor = UIColor.black.cgColor
    }
    
}


//MARK: Setup UI
extension QRCameraView {
    func setupUI(){
        self.setupScanAnimation()
    }

    func setupScanAnimation(){
        animationView = .init(name: "scan")

        animationView!.frame = self.bounds

        // 3. Set animation content mode

        animationView!.contentMode = .scaleAspectFill

        // 4. Set animation loop mode

        animationView!.loopMode = .loop

        // 5. Adjust animation speed

        animationView!.animationSpeed = 0.7

        self.addSubview(animationView!)

        // 6. Play animation

        animationView!.play()

    }

    func startAnimation(){
        self.animationView?.play()
    }
}

extension QRCameraView : AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            print("No QR Detected")
            delegate?.didReceiveDataQR(didReceive: false,string: "")
            return
        }
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            if metadataObj.stringValue != nil {
                print("QR Detected")
                delegate?.didReceiveDataQR(didReceive: true,string:  metadataObj.stringValue ?? "")
            }
        }
    }
    
}
