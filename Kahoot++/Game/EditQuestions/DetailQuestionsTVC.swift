//
//  DetailQuestionsTVC.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/18/21.
//

import UIKit

class DetailQuestionsTVC: UITableViewController {
    
    var question: QuestionStruct!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

class StepperCell: UITableViewCell {
    
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
    
}
