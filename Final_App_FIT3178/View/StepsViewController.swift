//
//  StepsViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 16/05/2023.
//

import UIKit

class StepsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var id: Int?
    
    
    var steps = [Instruction]()

    
    
    @IBOutlet weak var pageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        pageControl.currentPage = 0 
        pageControl.numberOfPages = steps.count
        performReq()
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return steps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slideCell", for: indexPath) as! SlidingCell
        
        let step = steps[indexPath.row]
        cell.instructionLabel.text = step.instructionStep
        return cell
    }
    
    func performReq(){
        guard let id = self.id else {
            return
        }
        let url = "https://api.spoonacular.com/recipes/\(id)/analyzedInstructions?apiKey=8a20103f31cd4cd49daadeeb8dfc99d8"

        
//        let url = "https://api.spoonacular.com/recipes/\(id)/analyzedInstructions?apiKey=75fb6b5ec943413cb3932877813f3226"
        Task{
            //check for valid url string
            guard let urlReq = URL(string:url) else{
                print("Invalid URL")
                return
            }
            //api request
            await getSteps(url: urlReq)
            collectionView.reloadData()
        }
        
    }
        
    func getSteps(url: URL) async{
        do{
            let(data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            //create a JSONDecoder instance
            let decoder = JSONDecoder()
            
            //Because the data returned is a JsonArray
            let resultContainer = try decoder.decode([RecipeStep.Instruction].self, from: data)
            print(resultContainer)
            for s in resultContainer{
                let instruction = Instruction()
                //get the steps array: which contains [equiment], [ingredients],number,step
                if let arrayOfSteps = s.steps{
                    //get the [equiement],step,number
                    for step in arrayOfSteps{
                        //do smtg with equipment array
                        if let equipments = step.equipment {
                            for i in equipments{
                                instruction.equipmentName = i.name
                                instruction.equipmentImage = i.image
                            }
                        }
                        //get the step & number
                        if let number = step.number{
                            instruction.instrcutionNumber = number
                        }
                        if let stepString = step.step{
                            instruction.instructionStep = stepString
                        }
                    }
                }
                steps.append(instruction)
            }
            
        }
        catch let error{
            print(error)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
        
        
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
    
    
}
