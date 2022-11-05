//
//  CameraModel.swift
//  Furin
//
//  Created by Long Hai on 11/4/22.
//

import Foundation
import SwiftUI
import AVFoundation

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var isTaken: Bool = false
    @Published var session = AVCaptureSession()
    @Published var alert: Bool = false
    
    //-- pic data
    @Published var output = AVCapturePhotoOutput()
    
    @Published var isSaved : Bool = false
    @Published var picData = Data(count: 0)
    
    //-- preview
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    
    @Published var capturedImage : UIImage!
    
    internal func checkPermission() {
        //-- checking permission
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case.authorized:
            setUp()
            return
        case .notDetermined:
            //-- pending for permission
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
            
        default:
            return
        }
    }
    
    
    internal func setUp() {
        //-- setting up camera
        do {
            
            
            
            //--setting configs
            self.session.beginConfiguration()
            
            
            //--ouput setting
            output.isHighResolutionCaptureEnabled = true
            
            //--choose camera
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
           
            let input = try AVCaptureDeviceInput(device: device!)
            
            //-- checking and adding to session
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            
            self.session.automaticallyConfiguresCaptureDeviceForWideColor = true
            
            self.session.commitConfiguration()
            
            self.session.startRunning()
            
        }catch {
            print(error.localizedDescription)
        }
    }
    
    internal func takePicture() {
        DispatchQueue.global(qos: .background).async {
            
            let setting = AVCapturePhotoSettings()
            setting.isAutoStillImageStabilizationEnabled = self.output.isStillImageStabilizationSupported
                
            self.output.capturePhoto(with: setting, delegate: self)

            self.session.stopRunning()
            
            DispatchQueue.main.async {
                withAnimation(.linear) {
                    self.isTaken.toggle()
                }
            }
        }
    }
    
    internal func reTake() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation(.linear) {
                    self.isTaken.toggle()
                    
                }
                //--clearing
                self.isSaved = false
            }
        }
    }
    
    internal func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            return
        }
        print("pic taken...")
        
        guard let imageData = photo.fileDataRepresentation() else {return}
        
        self.capturedImage = UIImage(data: imageData)
        //self.picData = imageData
    }
    
    internal func savePic() {
//        let width = UIScreen.main.bounds.size.width
//        let height = UIScreen.main.bounds.size.height
//
//        let margin = width * 0.1
//        let upperBound = height * 0.125
//
        
        //let image = UIImage(data: self.picData)! //.cgImage!.cropping(to: CGRect(x: 0, y: upperBound, width: width, height: width))!
        //let img = UIImage(cgImage: image)
        
        UIImageWriteToSavedPhotosAlbum(self.capturedImage, nil, nil, nil)
        
        self.isSaved = true
        print("Saved!")
    }
}


struct CameraPreview: UIViewRepresentable  {
    @ObservedObject var cameraModel: CameraModel
    
    func makeUIView(context: Context) -> some UIView {
        //let view = UIView(frame: UIScreen.main.bounds)
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let margin = width * 0.1
        let upperBound = height * 0.125
        
        let length = width - 2 * margin
        
        let view = UIView(frame: CGRect(x: 0, y: upperBound, width: width, height: width))

                          
        cameraModel.preview = AVCaptureVideoPreviewLayer(session: cameraModel.session)
        
        cameraModel.preview.frame = view.frame
        cameraModel.preview.cornerRadius = 20
        //-- custom prop
        cameraModel.preview.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(cameraModel.preview)
        
        //--starting sessions
        cameraModel.session.startRunning()
        
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //
    }
}
