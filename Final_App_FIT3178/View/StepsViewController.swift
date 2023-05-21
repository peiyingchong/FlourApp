//
//  StepsViewController.swift
//  Final_App_FIT3178
//
//  Created by Chong Pei Ying  on 16/05/2023.
//

import UIKit

class StepsViewController: UIViewController{
    
    var index = 0
    
    var id: Int?
    
    var steps = [Instruction]()

    @IBOutlet weak var instructionsTV: UILabel!
    
    @IBOutlet weak var stepNumber: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = steps.count + 1
        
        if index != 0 {
            index = 0
            stepNumber.text = "Firstly, Step 1: "
            instructionsTV.text = "\(steps[index].instructionStep!)"
        }else {
            stepNumber.text = "Firstly, Step 1: "
            instructionsTV.text = "\(steps[index].instructionStep!)"}
        
        
        // Do any additional setup after loading the view.
    }
    


    @IBAction func swipeToLeft(_ sender: Any) {
        //next step
        index += 1
        if index != steps.count {
            //instructionsTV.text = "\(index)"
            instructionsTV.text = " \(steps[index].instructionStep!)"
            stepNumber.text = "Step: \(index + 1)"
            //because the array has instructions of step 1 multiple time for different part of the recipe
            // so if we encounter another number 1, then it means it's the next part
            if steps[index].instrcutionNumber == 1 {
                stepNumber.text = "Next Thing that we have to do "
            }
        }
        else{
            //last step
            stepNumber.text = "Good Job! We are done"
            instructionsTV.text = ""
        }
        pageControl.currentPage = index
    }
    
    
    @IBAction func swipeToRight(_ sender: Any) {
        //previous step
        if index != 0 {
            index -= 1
            instructionsTV.text = " \(steps[index].instructionStep!)"
            if index == 0 {
                //check if it's the very beginning of the array 
                stepNumber.text = "Firstly, Step 1: "
            }
            else {
                stepNumber.text = "Step \(steps[index].instrcutionNumber!)"
                
            }
            pageControl.currentPage = index
        }
    }
    

}
