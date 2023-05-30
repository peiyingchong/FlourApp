//
//  IngredientListTableViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 14/05/2023.
//

import UIKit

class IngredientListTableViewController: UITableViewController {
    
    //nextSegue
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "nextSegue", sender: self)

    }
    
    var id: Int?
    var titled: String?
    //set the cell identifiers as constants
    let CELL_INGREDIENT = "IngredientCell"
    var listOfIngredients = [RecipeInfo]()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        self.tableView.allowsMultipleSelection = true
        
        performReq()
        
    }
    func performReq(){
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
            await getIngredients(url: urlReq)
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //only one section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfIngredients.count
    }

    
    //creates the cells to be displayed to the user
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INGREDIENT, for: indexPath)
        let ingredient = listOfIngredients[indexPath.row]
        
        //making the first letter uppercase
        let input = ingredient.name
        let firstLetter = input?.first!.uppercased()
        let remainingLetters = input!.dropFirst()
        cell.textLabel?.text = firstLetter! + remainingLetters
        
        //amount and unit are optionals so need to unwrap the values
        if let amount = ingredient.amount, let unit = ingredient.unitShort {
            cell.detailTextLabel?.text = "\(amount) \(unit)"

        }else{
            cell.detailTextLabel?.text = ""
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at:indexPath)?.accessoryType = .checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none

    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func getIngredients(url: URL) async{
        do{
            let(data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            //create a JSONDecoder instance
            let decoder = JSONDecoder()
            
            //Because the data returned is a JsonObject, and the field wanted is an array of Json Object
            let recipeData = try decoder.decode(RecipeInfo.IngredientList.self, from: data)
            if let ingredientList = recipeData.extendedIngredients{
                //the array of JsonObjects
                for ingredient in ingredientList{
                    let recipeInfo = RecipeInfo()
                    recipeInfo.name = ingredient.name
                    recipeInfo.amount = ingredient.measures.metric.amount
                    recipeInfo.unitShort = ingredient.measures.metric.unitShort
                    listOfIngredients.append(recipeInfo)
                }
                
            }
            self.tableView.reloadData()
        }
        catch let error{
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextSegue" {
            if let destination = segue.destination as? GetStartedViewController{
                destination.id = self.id
                destination.titled = self.titled
            }
        }
    }
    
}
