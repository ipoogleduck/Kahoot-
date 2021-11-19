//
//  EditQuestionsTVC.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/18/21.
//

import UIKit

class EditQuestionsTVC: UITableViewController, saveQuestionDelegate {
    
    var questions: [QuestionStruct]!
    
    var lastSelectedQuestionIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        questions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        let question = questions[indexPath.row]
        cell.titleLabel.text = question.question
        let type = question.type.displayName()
        let pointValue = question.points
        let pointString = (pointValue == 1) ? "\(pointValue)pt" : "\(pointValue)pts"
        cell.subTitleLabel.text = "\(type) - \(pointString)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailQuestionsTVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "DetailQuestionsTVC") as? DetailQuestionsTVC else {
            fatalError("Unable to Instantiate View Controller")
        }
        detailQuestionsTVC.delegate = self
        detailQuestionsTVC.question = questions[indexPath.row]
        lastSelectedQuestionIndex = indexPath.row
        navigationController?.pushViewController(detailQuestionsTVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func save(question: QuestionStruct) {
        questions[lastSelectedQuestionIndex] = question
        tableView.reloadData()
    }
    
}

class QuestionCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    
}
