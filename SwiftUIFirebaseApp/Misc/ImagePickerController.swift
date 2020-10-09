//
//  ImagePickerController.swift
//  SwiftUIFirebaseApp
//
//  Created by Jack Colley on 09/10/2020.
//

import SwiftUI
import Firebase

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage
    @Binding var attachedImageUrl: String
    @Environment(\.presentationMode) private var presentationMode
 
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
 
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
 
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
 
        return imagePicker
    }
 
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     
        var parent: ImagePicker
     
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
     
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
                let filename = UUID.init().uuidString
                let ref = Storage.storage().reference().child("images/\(filename)")
                let uploadData = parent.selectedImage.pngData()
                let metadata = StorageMetadata()
                metadata.contentType = "image/png"
                ref.putData(uploadData!, metadata: metadata, completion: { metadata, error in
                    ref.downloadURL(completion: { url, error in
                        if (url != nil) {
                            self.parent.attachedImageUrl = url!.absoluteString
                            self.parent.presentationMode.wrappedValue.dismiss()
                        } else {
                            print(error!)
                        }
                    })
                })
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
