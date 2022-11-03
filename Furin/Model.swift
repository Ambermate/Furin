//
//  Model.swift
//  Furin
//
//  Created by Long Hai on 11/2/22.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    @Published var yourSpeed : Double = 0.0
}

class Choose: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @Binding var isShown: Bool
    @Binding var myImage: Image
    
    init(isShown: Binding<Bool>, myImage: Binding<Image>) {
        _isShown = isShown
        _myImage = myImage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print(image)
            myImage = Image.init(uiImage: image)
        }
        isShown = false
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}
