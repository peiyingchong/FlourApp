//
//  RecipeOverview_ViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 15/05/2023.
//

import UIKit

class RecipeOverview_ViewController: UIViewController{
    
    
    var id: Int?
    var titled: String?
    var imageUrl: String?
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var servings: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var totalLikes: UILabel!
    
    @IBOutlet weak var healthScore: UILabel!
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var summaryView: UITextView!
    
    
    @IBOutlet weak var wineList: UITextView!
    
    
    @IBAction func startBaking(_ sender: Any) {
        self.performSegue(withIdentifier: "listSegue", sender: self)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let id = self.id else {
            return
        }
        let url = "https://api.spoonacular.com/recipes/\(id)/information?includeNutrition=false&apiKey=8a20103f31cd4cd49daadeeb8dfc99d8"
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
        
        // Do any additional setup after loading the view.
    }
    
    func getOverview(url: URL) async{
        do{
            let(data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            //create a JSONDecoder instance
            let decoder = JSONDecoder()
            
            
            let recipeData = try decoder.decode(RecipeInfo.IngredientList.self, from: data)
            DispatchQueue.main.async {
                self.titleLabel.text = self.titled ?? ""
                self.totalLikes.text = String(recipeData.aggregateLikes ?? 0)
                self.healthScore.text = String(recipeData.healthScore ?? 0)
                self.servings.text = String(recipeData.servings ?? 0)
                self.timeLabel.text = String(recipeData.readyInMinutes ?? 0)
                self.titleLabel.text = self.titled ?? ""
                self.wineList.text = recipeData.winePairing?.pairingText ?? ""
                
                if let summary = recipeData.summary {
                    let htmlString = summary
                    if let plainText = self.convertHTMLToPlainText(htmlString: htmlString) {
                        self.summaryView.text = plainText
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
                            self.imageView.image = image
                        }
                    }.resume()
                }
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listSegue" {
            if let destination = segue.destination as? IngredientListTableViewController{
                destination.id = self.id
            }
        }
        
    }
}
