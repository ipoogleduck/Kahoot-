//
//  TextAnswerVC.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/16/21.
//

import UIKit

class TextAnswerVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var mainTF: UITextField!
    
    var delegate: GameDelegate?
    var question: QuestionStruct!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = question.question
        mainTF.delegate = self
        mainTF.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let possibleAnswers = question.textAnswer!
        let myAnswer = mainTF.text ?? ""
        delegate?.showFeedback(from: self, correct: possibleAnswers.contains(myAnswer))
        return false
    }
    
}
