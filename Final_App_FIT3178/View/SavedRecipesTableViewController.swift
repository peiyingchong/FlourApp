//
//  SavedRecipesTableViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 21/05/2023.
//

import UIKit

class SavedRecipesTableViewController: UITableViewController {

    var savedRecipes : [RecipeEntity] = []
    
    let identifier = "recipeCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedRecipes = CoreDataController.shared.fetchSavedRecipes()
        
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return savedRecipes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let recipe = savedRecipes[indexPath.row]
        
        cell.textLabel?.text = recipe.title

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the recipe from core data
            let recipe = savedRecipes[indexPath.row]
            CoreDataController.shared.deleteRecipe(recipe: recipe)
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = savedRecipes[indexPath.row]
        self.performSegue(withIdentifier: "savedOverview", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "savedOverview" {
            if let destination = segue.destination as? RecipeOverview_ViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                let recipe = savedRecipes[indexPath.row]
                destination.id = Int(recipe.id)
                destination.titled = recipe.title
                destination.aggregateLikesProp = Int(recipe.like)
                destination.healthScoreProp = recipe.healthScore
                destination.summaryProp = recipe.summary
                destination.readyInMinutesProp = Int(recipe.readyTime)
                destination.servingsProp = recipe.serving
                destination.wineListPairingProp = recipe.winePairing
            }
        }
    }

}
