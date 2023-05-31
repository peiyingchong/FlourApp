//
//  StorageManager.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 28/05/2023.
//

import Foundation
import FirebaseStorage
import Firebase
import UIKit
import FirebaseDatabase



public class StorageManager{
    
    static let shared = StorageManager()
    
    
    func uploadToFirebase(model: UserPostViewModel){
        guard let uid = model.userId else{
            return
        }
        let ref =  Database.database().reference()
        let storage = Storage.storage().reference(forURL: "gs://fit3178-finalapp-6ba0e.appspot.com")
        
        //creating a posts branch in database
        let key = ref.child("posts").childByAutoId().key
        
        //put the posts under the userID in storage          //created a jpg file with the name of the post image
        let imageRef = storage.child("posts").child(uid).child("\(key).jpg")
        
        
        let uploadTask = imageRef.putData(model.photoData!, metadata: nil){ (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            imageRef.downloadURL(completion:  { (url,error) in
                //if url is not nill
                if let url = url {
                    //create a dictionary
                    let feed  = ["userID" : uid ,"recipeId": model.recipeId, "pathToImage" : url.absoluteString, "title": model.title, "postkey" : key, "comment": model.comment,"postID":model.postID] as [String: Any]
                    
                    //creating a specific id and putting the feed under that branch
                    let postFeed = ["\(key)": feed]
                    
                    ref.child("posts").updateChildValues(postFeed)
                    print("uploadSuccessful")
                }
            })
        }
        uploadTask.resume()
        
    }
    
 
}

