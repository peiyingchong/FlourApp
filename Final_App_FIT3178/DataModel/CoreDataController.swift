//
//  CoreDataController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 21/05/2023.
//

import UIKit
import CoreData
import SwiftUI
class CoreDataController: NSObject {
    
    static let shared = CoreDataController()
    var persistentContainer: NSPersistentContainer
    
    
    override init() {
        //initialises persistentContainer property
        persistentContainer = NSPersistentContainer(name:"RecipesDataModel")
        //loads the core data stack, and provide a closure for error handling
        persistentContainer.loadPersistentStores() {(description, error ) in
            if let error = error {
                fatalError("Failed to load Core Data Stack with error: \(error)")
            }
        }
        super.init()
    }
    
    func save() {
        //This method will check to see if there are changes to be saved inside of the view context and then save, as necessary.
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save changes to Core Data with error: \(error)")
            } }
    }
    
    func addRecipe(id: Int, title: String, image: Data, servings: Double, likes: Int, health: Double, readyTime: Int, summary: String, winePairing: String)  -> RecipeEntity {
        let recipe = NSEntityDescription.insertNewObject(forEntityName: "RecipeEntity", into: persistentContainer.viewContext) as! RecipeEntity
        recipe.id = Int32(id)
        recipe.title = title
        recipe.image = image
        recipe.serving = servings
        recipe.like = Int32(likes)
        recipe.healthScore = health
        recipe.readyTime = Int32(readyTime)
        recipe.summary = summary
        recipe.winePairing = winePairing
        
        save()
        return recipe
    }
    
    func deleteRecipe(recipe: RecipeEntity) {
        persistentContainer.viewContext.delete(recipe)
        save()
    }
    
    func fetchSavedRecipes() -> [RecipeEntity] {
        var recipes = [RecipeEntity]()
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        do {
            try recipes = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request failed with error: \(error)")
        }
        return recipes
    }
    
    
    
    func checkSavedStatus(id:Int) -> Bool{
        let savedRecipes = fetchSavedRecipes()
        //if already saved return true
        if let entity = savedRecipes.first(where: {$0.id == Int32(id)}) {
            return true
        }else{
            return false
        }
    }
    
    func fetchRecipe(id:Int) -> RecipeEntity{
        let savedRecipes = fetchSavedRecipes()
        //if already saved return true
        let entity = savedRecipes.first(where: {$0.id == Int32(id)})
        return entity!
        
    }
    
   

    
}
