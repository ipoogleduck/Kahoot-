//
//  DetailQuestionsTVC.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/18/21.
//

import UIKit

class DetailQuestionsTVC: UITableViewController, LongTextDelegate {
    
    var delegate: saveQuestionDelegate?
    var question: QuestionStruct!
    
    var lastSelectedTypeIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set indexpath of currently selected option so it can be deselcted later when needed
        if let row = QuestionType.allCases.firstIndex(where: {$0 == question.type}) {
            lastSelectedTypeIndex = IndexPath(row: row, section: 1)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return QuestionType.allCases.count
        } else if section == 2 {
            if question.type == .textAnswer {
                return 1
            } else if question.type == .multipleChoice {
                return 1
            } else {
                return 2
            }
        } else {
            return 1
        }
    }
    
    //Keeping this out for now because it looks better without headers
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "Question"
//        } else if section == 1 {
//            return "Question Type"
//        } else if section == 2 {
//            return nil
//        } else {
//            return "Question Points"
//        }
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MLLabelCell", for: indexPath) as! BasicLabelCell
            //If there is no question inputted, it will say "Add Question Here"
            cell.mainLabel.text = (question.question == "") ? "Add Question Here" : question.question
            cell.mainLabel.textColor = .secondaryLabel
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCell", for: indexPath) as! BasicLabelCell
            let choice = QuestionType.allCases[indexPath.row]
            cell.mainLabel.text = choice.displayName()
            //Set checkmark on selected type
            cell.accessoryType = (question.type == choice) ? .checkmark : .none
            return cell
        } else if indexPath.section == 2 {
            if question.type == .textAnswer {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MLLabelCell", for: indexPath) as! BasicLabelCell
                cell.mainLabel.text = "Edit Valid Answers"
                cell.mainLabel.textColor = .label
                return cell
            } else if question.type == .multipleChoice {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MLLabelCell", for: indexPath) as! BasicLabelCell
                cell.mainLabel.text = "Edit Choices"
                cell.mainLabel.textColor = .label
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCell", for: indexPath) as! BasicLabelCell
                let row = indexPath.row
                if row == 0 {
                    cell.mainLabel.text = "True"
                } else {
                    cell.mainLabel.text = "False"
                }
                //Set checkmark on selected type
                let trueOrFalse = question.trueOrFalse
                cell.accessoryType = ((trueOrFalse && row == 0) || (!trueOrFalse && row == 1)) ? .checkmark : .none
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StepperCell", for: indexPath) as! StepperCell
            updateStepperCellText(for: cell)
            cell.stepper.value = Double(question.points)
            cell.stepper.addTarget(self, action: #selector(tappedStepper), for: .valueChanged)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            guard let longTextVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "LongTextVC") as? LongTextVC else {
                fatalError("Unable to Instantiate View Controller")
            }
            longTextVC.delegate = self
            longTextVC.title = "Edit Question"
            longTextVC.text = question.question
            longTextVC.isEditable = true
            navigationController?.pushViewController(longTextVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        } else if indexPath.section == 1 {
            //Changes selected type of question
            question.type = QuestionType.allCases[indexPath.row]
            //Saves update
            saveQuestion()
            //Removes checkmark on old cell
            if let lastIndex = lastSelectedTypeIndex, let cell = tableView.cellForRow(at: lastIndex) {
                cell.accessoryType = .none
            }
            //Adds chedckmark on new cell
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
            }
            //Reloads section 2
            tableView.reloadSections([2], with: .none)
            //Sets last selected cell
            lastSelectedTypeIndex = indexPath
        } else if indexPath.section == 2 {
            //Sets true or false to the selected row
            question.trueOrFalse = indexPath.row == 0
            //Saved update
            saveQuestion()
            //Gets opposite of selected row
            let oppositeRow = indexPath.row == 0 ? 1 : 0
            //Deselects at that row
            if let cell = tableView.cellForRow(at: IndexPath(row: oppositeRow, section: 2)) {
                cell.accessoryType = .none
            }
            //Selects at selected row
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
            }
        }
    }
    
    @objc func tappedStepper(_ sender: UIStepper) {
        question.points = Int(sender.value)
        saveQuestion()
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? StepperCell {
            updateStepperCellText(for: cell)
        }
    }
    
    func updateStepperCellText(for cell: StepperCell) {
        let pointsString = (question.points == 1) ? "Point" : "Points"
        cell.mainLabel.text = "\(question.points) \(pointsString)"
    }
    
    func saveQuestion() {
        delegate?.save(question: question)
    }
    
    func save(text: String) {
        question.question = text
        saveQuestion()
        tableView.reloadData()
    }
    
}

protocol saveQuestionDelegate {
    func save(question: QuestionStruct)
}

class StepperCell: UITableViewCell {
    
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
    
}
