//
//  GetStartedViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 20/05/2023.
//

import UIKit

class GetStartedViewController: UIViewController {
    
    
    var id: Int?
    
    var steps = [Instruction]()
    
    var titled: String?
    
    @IBAction func onGetStarted(_ sender: Any) {
        self.performSegue(withIdentifier: "instructionsSegue", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assignbackground()

        
        guard let id = self.id else {
            return
        }
        let url = "https://api.spoonacular.com/recipes/\(id)/analyzedInstructions?apiKey=8a20103f31cd4cd49daadeeb8dfc99d8"
        //75fb6b5ec943413cb3932877813f3226
//        let url = "https://api.spoonacular.com/recipes/\(id)/analyzedInstructions?apiKey=8a20103f31cd4cd49daadeeb8dfc99d8"

        Task{
            //check for valid url string
            guard let urlReq = URL(string:url) else{
                print("Invalid URL")
                return
            }
            //api request
            await getSteps(url: urlReq)
        }
        // Do any additional setup after loading the view.
    }
    
    
    func assignbackground(){
        let background = UIImage(named: "Ready")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleToFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
    }
    
        
    func getSteps(url: URL) async{
        do{
            let(data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            //create a JSONDecoder instance
            let decoder = JSONDecoder()
            
            //Because the data returned is a JsonArray
            let resultContainer = try decoder.decode([RecipeStep.Instruction].self, from: data)
            for s in resultContainer{
                //get the steps array: which contains [equiment], [ingredients],number,step
                if let arrayOfSteps = s.steps{
                    //get the [equiement],step,number
                    for item in arrayOfSteps{
                        let instruction = Instruction()
                        //get the step & number
                        instruction.instrcutionNumber = item.number
                        instruction.instructionStep = item.step
                        steps.append(instruction)
                    }
                }
            }
        }
        catch let error{
            print(error)
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "instructionsSegue" {
            if let destination = segue.destination as? StepsViewController{
                destination.steps = self.steps
                destination.id = self.id
                destination.titled = self.titled
            }
        }
    }

   
}

