//
//  SearchRecipesTableViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 15/05/2023.
//

import UIKit

class SearchRecipesTableViewController: UITableViewController ,UISearchBarDelegate{
    
    
    
    var indicator = UIActivityIndicatorView()
    
    var newRecipes = [RecipeData]()

    let CELL = "recipeCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController

        // Add a loading indicator view
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([indicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),indicator.centerYAnchor.constraint(equalTo:view.safeAreaLayoutGuide.centerYAnchor)])
        
        definesPresentationContext = true



    }

    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
           searchBar.showsCancelButton = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newRecipes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL, for: indexPath)
        let recipe = newRecipes[indexPath.row]
        
        cell.textLabel?.text = recipe.title
        
        //fetch image from url
        let url = URL(string:recipe.image)
        
        //peform network dataTask asynchronously, downloading image from url
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
                guard let data = data, let image = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async {
                    let myImageView:UIImageView = UIImageView()
                    myImageView.frame.size.width = 200
                    myImageView.frame.size.height = 200
                    myImageView.center = self.view.center
                    myImageView.layer.cornerRadius = 100
                    myImageView.clipsToBounds = true
                    myImageView.image = image
                    if let currentIndexPath = tableView.indexPath(for: cell),
                                       currentIndexPath == indexPath {
                        cell.imageView?.image = image
 
                    }
                }
            //Once the data task is created, you call resume() on it to start the network request. start downloading
        }.resume()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = newRecipes[indexPath.row]
        self.performSegue(withIdentifier: "recipeOverviewSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeOverviewSegue" {
            if let destination = segue.destination as? RecipeOverview_ViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                let recipe = newRecipes[indexPath.row]
                destination.id = recipe.id
                destination.titled = recipe.title
                destination.imageUrl = recipe.image
            }
        }
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

    
    
    func getRecipes(url: URL) async{
        do{
            let(data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }
            //create a JSONDecoder instance
            let decoder = JSONDecoder()
            
            //Because the data returned is a JsonObject, and the field wanted is an array of Json Object
            let resultContainer = try decoder.decode(SearchRecipe.self, from: data)
            if let recipe = resultContainer.recipes{
                for item in recipe {
                    newRecipes.append(item)
                }
            }
        }
        catch let error{
            print(error)
        }
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, searchText.isEmpty == false else{
            return
        }
        //empty current list of newBooks
        newRecipes.removeAll()
        //refresh the table view
        tableView.reloadData()
      
        navigationItem.searchController?.dismiss(animated: true)
        indicator.startAnimating()
        URLSession.shared.invalidateAndCancel()
        let url = "https://api.spoonacular.com/recipes/complexSearch?query=\(searchText)&type=bread&apiKey=8a20103f31cd4cd49daadeeb8dfc99d8"
//        let url = "https://api.spoonacular.com/recipes/complexSearch?query=\(searchText)&apiKey=75fb6b5ec943413cb3932877813f3226"
        Task{
            //check for valid url string
            guard let urlReq = URL(string:url) else{
                print("Invalid URL")
                return
            }
            //api request
            await getRecipes(url: urlReq)
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    
}
