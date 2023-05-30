//
//  RecipeOverview_ViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 15/05/2023.
//

import UIKit
import SwiftUI
import CoreData


class RecipeOverview_ViewController: UIViewController{
    
    @IBOutlet weak var savedButton: UIButton!
    
    var id: Int?
    var titled: String?
    var imageUrl: String?
    var servingsProp: Double?
    var aggregateLikesProp: Int?
    var healthScoreProp: Double?
    var readyInMinutesProp: Int?
    var summaryProp: String?
    var wineListPairingProp: String?
    var imageData: Data?
    
    var status: Bool?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var servings: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var totalLikes: UILabel!
    
    
    @IBOutlet weak var healthScore: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var summaryView: UITextView!
    
    
    @IBOutlet weak var wineList: UITextView!
    
    @IBAction func onSaveRecipe(_ sender: Any) {
        
        CoreDataController.shared.addRecipe(id: self.id!, title: self.titled!, image: self.imageData!, servings: self.servingsProp!, likes: self.aggregateLikesProp!, health: self.healthScoreProp!, readyTime: self.readyInMinutesProp! , summary: self.summaryProp!, winePairing: self.wineListPairingProp!)
        
        status = CoreDataController.shared.checkSavedStatus(id: self.id!)
        listenForSaveChanges()
    }
    
    var steps = [Instruction]()
    
    
    @IBAction func startBaking(_ sender: Any) {
        self.performSegue(withIdentifier: "listSegue", sender: self)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        status = CoreDataController.shared.checkSavedStatus(id: self.id!)
        listenForSaveChanges()
        
       
        if status == true{
            //load using coreData
            Task{
                await fetchARecipe()
            }
            print("fetched using core data")
        }else{
            Task{
                await performApiReq()
            }
            print("fetched using api")
        }
        DispatchQueue.main.async{
            self.setTV()
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func getOverview(url: URL) async{
        do{
            let(data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            //create a JSONDecoder instance
            let decoder = JSONDecoder()
            
            
            let recipeData = try decoder.decode(RecipeInfo.IngredientList.self, from: data)
            DispatchQueue.main.async {
                //self.titleLabel.text = self.titled ?? ""
                //self.totalLikes.text = "Likes: " + String(recipeData.aggregateLikes ?? 0)
//                self.healthScore.text = "Health: " + String(recipeData.healthScore ?? 0)
//                self.servings.text = "Servings: " + String(recipeData.servings ?? 0)
//                self.timeLabel.text = "Time: " + String(recipeData.readyInMinutes ?? 0)
//                self.wineList.text = recipeData.winePairing?.pairingText ?? ""
                
                self.aggregateLikesProp = recipeData.aggregateLikes ?? 0
                self.healthScoreProp = recipeData.healthScore ?? 0
                print(recipeData.healthScore)
                self.servingsProp = recipeData.servings ?? 0
                self.readyInMinutesProp = recipeData.readyInMinutes ?? 0
                self.wineListPairingProp = recipeData.winePairing?.pairingText ?? ""
                
                if let summary = recipeData.summary {
                    let htmlString = summary
                    if let plainText = self.convertHTMLToPlainText(htmlString: htmlString) {
                        self.summaryProp = plainText
                        print("here")
                        //self.summaryView.text = plainText
                    } else {
                        print("Failed to convert HTML to plain text.")
                    }
                }
                
                if let url = self.imageUrl {
                    let url = URL(string: url)
                    URLSession.shared.dataTask(with: url!) { (data, response, error) in
                        guard let data = data, let image = UIImage(data: data) else {
                            return
                        }
                        DispatchQueue.main.async {
                            self.imageData = image.pngData()
                            self.imageView.image = image
                        }
                    }.resume()
                }
                self.setTV()
                self.reloadInputViews()
            }
        }
        
        
        catch let error{
            print(error)
        }
    }
    
    func convertHTMLToPlainText(htmlString: String) -> String? {
        guard let data = htmlString.data(using: .utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributedString.string
        }
        
        return nil
    }
    
    func setTV(){
        print("setTV")
        self.titleLabel.text = self.titled!
        self.totalLikes.text = "Likes: \(self.aggregateLikesProp ?? 0)"
        self.healthScore.text = "Health: \(self.healthScoreProp ?? 0)"
        self.servings.text = "Servings: \(self.servingsProp ?? 0)"
        self.timeLabel.text = "Time: \(self.readyInMinutesProp ?? 0)"
        self.summaryView.text = self.summaryProp ?? ""
        self.wineList.text = self.wineListPairingProp ?? ""
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listSegue" {
            if let destination = segue.destination as? IngredientListTableViewController{
                destination.id = self.id
                destination.titled = self.titled
            }
        }
        
    }
    
    func listenForSaveChanges(){
        //if user already saved to coredata
        if status == true{
            savedButton.setTitle("saved", for: .normal)
        }
//        else{
//            savedButton.setTitle("save", for: .normal)
//            savedButton.isEnabled = true
//        }
    }
    
    
    //MARK: fetch recipes from API
    func performApiReq(){
        let url = "https://api.spoonacular.com/recipes/\(self.id!)/information?includeNutrition=false&apiKey=8a20103f31cd4cd49daadeeb8dfc99d8"
//        let url = "https://api.spoonacular.com/recipes/\(id)/information?includeNutrition=false&apiKey=75fb6b5ec943413cb3932877813f3226"
        Task{
            //check for valid url string
            guard let urlReq = URL(string:url) else{
                print("Invalid URL")
                return
            }
            //api request
            await getOverview(url: urlReq)
        }
    }
    
    //MARK: fetch recipes from core data
    func fetchARecipe(){
        let entity = CoreDataController.shared.fetchRecipe(id: self.id!)
        self.titled = entity.title
        self.aggregateLikesProp = Int(entity.like)
        self.healthScoreProp = entity.healthScore
        self.servingsProp = entity.serving
        self.readyInMinutesProp = Int(entity.readyTime)
        self.summaryProp = entity.summary
        self.wineListPairingProp = entity.winePairing
        
        guard let image = UIImage(data: entity.image!) else {
            return
        }
        // Display the image in the UIImageView
        imageView.image = image
    }
    
    
}

    

