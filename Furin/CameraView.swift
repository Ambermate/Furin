//
//  CameraView.swift
//  Furin
//
//  Created by Long Hai on 11/4/22.
//

import SwiftUI

struct CameraView: View {
    @StateObject var cameraModel = CameraModel()
    
    var body: some View {
        ZStack {
            CameraPreview(cameraModel: cameraModel)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                Spacer()
                
                //-- if taken, show post option and retake
                if cameraModel.isTaken {
                    HStack {
                        Button(action: {cameraModel.reTake()}) {
                            Text("cancel")
                        }
                        Button(action: {cameraModel.isTaken.toggle()}) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 65, height: 65)
                        }
                        
                        Button(action: {
                            if !cameraModel.isSaved {
                                cameraModel.savePic()
                            }
                        }) {
                            Text(cameraModel.isSaved ? "Saved" : "Save")
                        }
                    }
                }
                else {
                    HStack {
                        Button(action: {cameraModel.takePicture()}) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75)
                            }
                        }
                    }
                }
                Spacer()
                    .frame(height: 20)
            }
        }
        .onAppear {
            cameraModel.checkPermission()
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
