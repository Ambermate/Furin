//
//  CameraView.swift
//  Furin
//
//  Created by Long Hai on 11/4/22.
//

import SwiftUI

struct CameraView: View {
    @StateObject var camera = CameraModel()
    
    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                Spacer()
                
                //-- if taken, show post option and retake
                if camera.isTaken {
                    HStack {
                        Button(action: {}) {
                            Text("cancel")
                        }
                        Button(action: {camera.isTaken.toggle()}) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 65, height: 65)
                        }
                        
                        Button(action: {
                            if !camera.isSaved {
                                camera.savePic()
                            }
                        }) {
                            Text(camera.isSaved ? "Saved" : "Save")
                        }
                    }
                }
                else {
                    HStack {
                        Button(action: {camera.takePicture()}) {
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
            camera.checkPermission()
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
