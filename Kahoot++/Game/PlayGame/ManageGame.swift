//
//  ManageGame.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/16/21.
//

import Foundation
import UIKit

enum QuestionType: Codable {
    case textAnswer
    case multipleChoice
    case trueFalse
    
    func displayName() -> String {
        switch self {
        case .textAnswer:
            return "Text Answer"
        case .multipleChoice:
            return "Multiple Choice"
        case .trueFalse:
            return "True or False"
        }
    }
}

struct MultipleChoice: Codable {
    var answer: String
    var correct: Bool
}

struct QuestionStruct: Codable {
    var question: String
    var type: QuestionType
    var trueOrFalse: Bool?
    var multipleChoice: [MultipleChoice]?
    var textAnswer: [String]?
    var points: Int
}

let exampleGame = [
    QuestionStruct(question: "Is 2+2 equal to 4?", type: .trueFalse, trueOrFalse: true, points: 10),
    QuestionStruct(question: "Ariel was playing basketball. 1 of her shots went in the hoop. 2 of her shots did not go in the hoop. How many shots were there in total?", type: .multipleChoice, multipleChoice: [MultipleChoice(answer: "2", correct: false), MultipleChoice(answer: "7", correct: false), MultipleChoice(answer: "6383", correct: false), MultipleChoice(answer: "3", correct: true)], points: 15),
    QuestionStruct(question: "Last hockey season, Jack scored g goals. Patrik scored twice as many goals than Jack. Write an expression that shows how many goals Patrik scored using f(x).", type: .textAnswer, textAnswer: ["f(x) = 2g", "f(x)=2g", "f(x)= 2g", "f(x) =2g"], points: 20),
]

extension SubjectTVC: GameDelegate {

    func startGame(from viewController: UIViewController) {
        game.shuffle()
        continueGame(from: viewController)
    }

    func continueGame(from viewController: UIViewController) {
        if currentQuestionIndex < game.count {
            let currentQuestion = game[currentQuestionIndex]
            
            if currentQuestion.type == .textAnswer {
                guard let textAnswerVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TextAnswerVC") as? TextAnswerVC else {
                    fatalError("Unable to Instantiate View Controller")
                }
                textAnswerVC.delegate = self
                textAnswerVC.question = currentQuestion
                textAnswerVC.modalPresentationStyle = .fullScreen
                viewController.present(textAnswerVC, animated: true)
            } else if currentQuestion.type == .multipleChoice {
                guard let MCVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MCVC") as? MCVC else {
                    fatalError("Unable to Instantiate View Controller")
                }
                MCVC.delegate = self
                MCVC.question = currentQuestion
                MCVC.modalPresentationStyle = .fullScreen
                viewController.present(MCVC, animated: true)
            } else {
                guard let TFVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TFVC") as? TFVC else {
                    fatalError("Unable to Instantiate View Controller")
                }
                TFVC.delegate = self
                TFVC.question = currentQuestion
                TFVC.modalPresentationStyle = .fullScreen
                viewController.present(TFVC, animated: true)
            }
            
        } else {
            print("Yaya you're done")
            viewController.performSegue(withIdentifier: "toDoneWithGameSegue", sender: self)
        }
    }
    
    func showFeedback(from viewController: UIViewController, correct: Bool) {
        let currentQuestion = game[currentQuestionIndex]
        
        guard let FeedbackVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "FeedbackVC") as? FeedbackVC else {
            fatalError("Unable to Instantiate View Controller")
        }
        FeedbackVC.delegate = self
        FeedbackVC.modalPresentationStyle = .fullScreen
        FeedbackVC.modalTransitionStyle = .crossDissolve
        
        FeedbackVC.question = currentQuestion.question
        FeedbackVC.correct = correct
        FeedbackVC.leaderboard = exampleLeaderboard
        
        currentQuestionIndex += 1
        
        viewController.present(FeedbackVC, animated: true)
    }
    
}

protocol GameDelegate {
    func continueGame(from viewController: UIViewController)
    func showFeedback(from viewController: UIViewController, correct: Bool)
}

