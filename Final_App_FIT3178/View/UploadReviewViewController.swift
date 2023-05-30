//
//  UploadReviewViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 26/05/2023.
//

import UIKit
import PhotosUI
import FirebaseStorage

class UploadReviewViewController: UIViewController,UIImagePickerControllerDelegate, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var image: Data?
    var id: Int?
    var titled: String?
    
    @IBOutlet weak var commentText: UITextField!
    
    @IBAction func submitButton(_ sender: Any) {
        
        guard let uid = FirebaseController.shared.currentUser?.uid else {
            return
        }
        let post = UserPostViewModel(userId: uid, recipeId: id ?? 0, title: titled, photoData: image, comment: commentText.text)
        
        StorageManager.shared.uploadToFirebase(model: post)
        
        self.performSegue(withIdentifier: "doneUpload", sender: self)
        
        
        
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func uploadButton(_ sender: Any) {
        let alert = UIAlertController(title: "UploadImage", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default,handler:  {
            (handler) in self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default,handler:  {
            (handler) in self.openLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in
            // Handle cancel action
            self.dismiss(animated: true, completion: nil)
        })
        self.present(alert,animated: true,completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FirebaseController.shared.currentUser?.uid)
        titleLabel.text = titled
        // Do any additional setup after loading the view.
    }
    
    // MARK: CAMERA
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
    }
    
    //when user hit cancel button in camera view
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //user clicks on use photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //*
        // MARK: - DECISION TO BE DONE
        //this is the image, decide what to do with it later
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            return
        }
        
        guard let imageData = image.pngData() else {
            return
        }
        self.image = imageData
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: PHOTO LIBRARY
    func openLibrary(){
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        //only images allowed ,not livePhotos/videos
        config.filter = PHPickerFilter.images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true )
    }
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        print("finished picking image")
        results.forEach{result in
            result.itemProvider.loadObject(ofClass: UIImage.self){ reading, error in
                guard let image = reading as? UIImage, error == nil else{
                    return
                }
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
                self.image = image.jpegData(compressionQuality: 0.8)
                print(image)
                print("self.image: \(self.image)")
            }
        }
    }
   

}
