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
    
    var titled: String?
    
    
    @IBAction func writeReviewButton(_ sender: Any) {
        self.performSegue(withIdentifier: "reviewSegue", sender: self)
    }
    
    var steps = [Instruction]()

    @IBOutlet weak var instructionsTV: UILabel!
    
    @IBOutlet weak var stepNumber: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    @IBOutlet weak var reviewButton: UIButton!
    
    
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewButton.isHidden = true
        skipButton.isHidden = true
        
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
        reviewButton.isHidden = true
        skipButton.isHidden = true
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
            reviewButton.isHidden = false
            skipButton.isHidden = false
        }
        pageControl.currentPage = index
    }
    
    
    @IBAction func swipeToRight(_ sender: Any) {
        reviewButton.isHidden = true
        skipButton.isHidden = true
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reviewSegue" {
            if let destination = segue.destination as? UploadReviewViewController{
                destination.id = self.id
                destination.titled = self.titled
                
            }
        }
        
    }
    

}
