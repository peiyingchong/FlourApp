//
//  CommunityViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 28/05/2023.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class CommunityViewController: UIViewController {
    
    private let refreshControl = UIRefreshControl()
    
    private var posts = [UserPostViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ReviewPostTableViewCell.self, forCellReuseIdentifier: ReviewPostTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        
        //the view controller indicates that it will handle the delegate and data source responsibilities for the table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // Add the refresh control to the table view
        tableView.refreshControl = refreshControl
           
        // Set the action for the refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        
        //fetchPosts()
        
        print("posts.count: \(posts.count)")
        
        // Do any additional setup after loading the view.
    }
    
    @objc private func refreshData() {
        // Perform the data refreshing or reloading here
        
        // call your fetchPosts() method to reload the data
        fetchPosts()
        
        // End the refreshing state
        refreshControl.endRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    func fetchPosts() {
        let ref = Database.database().reference()
        
        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            guard let postsSnap = snapshot.value as? [String: Any] else {
                return
            }
            
            // Loop through all the posts
            for (_, postData) in postsSnap {
                //bcz postData is of type AnyObject, we cast it as String
                guard let post = postData as? [String: Any] else{
                    return}
                if let recipeId = post["recipeId"] as? Int,
                   let userID = post["userID"] as? String,
                   let title = post["title"] as? String,
                   let imagePath = post["pathToImage"] as? String,
                   let comment = post["comment"] as? String,
                   let postId = post["postID"] as? String{

                    //check if posts already exist because we dont want to append again after refreshing
                    let postExists = self.posts.contains { $0.postID == postId }
                        
                    if !postExists {
                        print("recipeid: \(recipeId)")
                        self.fetchImage(for: imagePath) { result in
                            switch result {
                            case .success(let imageData):
                                // Use the image data
                                let postViewModel = UserPostViewModel(userId: userID, recipeId: recipeId, title: title, photoData: imageData, comment: comment, postID: postId)
                                
                                self.posts.append(postViewModel)
                                
                                print("Image data:", imageData)
                            case .failure(let error):
                                // Handling the error
                                print("Error fetching image:", error)
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        )}
    //    ref.removeAllObservers()
    
    func fetchImage(for imageURL: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: imageURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let imageData = data {
                completion(.success(imageData))
            } else {
                completion(.failure(NSError(domain: "No image data", code: 0, userInfo: nil)))
            }
        }.resume()
    }
}
extension CommunityViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    //each section corresponds to 1 post
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //insdie one section, we only need one 1 row
    func tableView(_ tableView:  UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewPostTableViewCell.identifier, for: indexPath) as? ReviewPostTableViewCell else{
            return UITableViewCell()
        }
        
        cell.configure(with: posts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "communityToOverviewVC", sender: self)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "communityToOverviewVC" {
            if let destination = segue.destination as? RecipeOverview_ViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                let post = posts[indexPath.row]
                destination.id = post.recipeId
                destination.titled = post.title
            }
        }
    }
    
    
    
    
}

//Represents a User Post
public struct ReviewPost: Codable {
    let identifier: String
    let recipeId: Int
    let photoURL: URL
    let title: String?
    let comments: [PostComment]
    let createdDate: Date
}

struct PostComment: Codable{
    let identifier: String
    let text: String
}
