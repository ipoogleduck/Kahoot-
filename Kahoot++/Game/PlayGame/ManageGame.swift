//
//  ManageGame.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/16/21.
//

import Foundation
import UIKit
import ALRT

/// This enum contains the possible answer types for questions.
///
/// Call the displayName function to return a string of how the answer type is written in plain text
///
/// ```
/// func displayName() -> String
/// ```
enum QuestionType: Codable, CaseIterable {
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

/// This structure for multiple choice questions conatains an answer to the multiple choice question and whether it is correct or not
struct MultipleChoice: Codable {
    var answer: String
    var correct: Bool
}

/// This structure contains a single question.
/// It mainly contains the question itself, the type of question, the answer(s), and the amount of points
struct QuestionStruct: Codable {
    var question: String //The question being asked as a string
    var type: QuestionType //This is used by the code to deturmin the question types as some of the below variables are optional but may contain data even when not selected
    var trueOrFalse: Bool = true //Default is true so that there is an option selected by default if the teacher sets the question to true/false
    var multipleChoice: [MultipleChoice]? //An array of 4 multiple choice questions
    var textAnswer: [String]? //An array of correct answers (there can be more than one if needed)
    var points: Int
}

extension SubjectTVC: GameDelegate {
    
    /// Checks if course questions are empty.
    /// If empty, it will display an alert telling the user that no questions have been set by the instructor.
    /// Otherwise, it will shuffle the questions and call *continueGame()*
    /// - Parameter viewController: the view controller from which the next VC will be presented from
    func startGame(from viewController: UIViewController) {
        if course.questions.isEmpty {
            ALRT.create(.alert, title: "Game Unavailable", message: "The instructor has not set any questions for this game").addOK().show() //Shows alert
        } else {
            course.questions.shuffle() //Randomizes questions
            continueGame(from: viewController)
        }
    }
    
    
    /// Checks if it's ran through all the available questions.
    /// If it has, it will display the *doneWithGameVC*, which contains an option for viewing the scoreboard, replaying the game, or exiting.
    /// If there are still questiosn left, the function will present the corresonding view controller
    /// - Parameter viewController: the view controller from which the next VC will be presented from
    func continueGame(from viewController: UIViewController) {
        if currentQuestionIndex < course.questions.count {
            let currentQuestion = course.questions[currentQuestionIndex]
            
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
            guard let doneWithGameVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "DoneWithGameVC") as? DoneWithGameVC else {
                fatalError("Unable to Instantiate View Controller")
            }
            doneWithGameVC.leaderboard = course.leaderboard
            doneWithGameVC.modalPresentationStyle = .fullScreen
            viewController.present(doneWithGameVC, animated: true)
        }
    }
    
    
    /// This function is called by one if the question answer VC's and displays info on the current question and if it was correct, as well as the leaderboard.
    /// - Parameters:
    ///   - viewController: the view controller from which the next VC will be presented from.
    ///   - correct: whether the student selected the correct question.
    func showFeedback(from viewController: UIViewController, correct: Bool) {
        let currentQuestion = course.questions[currentQuestionIndex] //Gets "last" question from course
        
        guard let FeedbackVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "FeedbackVC") as? FeedbackVC else {
            fatalError("Unable to Instantiate View Controller")
        }
        FeedbackVC.delegate = self
        FeedbackVC.modalPresentationStyle = .fullScreen
        FeedbackVC.modalTransitionStyle = .crossDissolve
        
        FeedbackVC.question = currentQuestion.question
        FeedbackVC.correct = correct
        FeedbackVC.leaderboard = exampleLeaderboard
        
        currentQuestionIndex += 1 //Updates status to next question
        
        viewController.present(FeedbackVC, animated: true)
    }
    
}


/// This delegate is used by *TextAnswerVC*, *MCVC*, and *TFVC* which will call *showFeedback()* when the question has been answered in order to  dispaly *FeedbackVC*.
/// It can also be used by *FeedbackVC* to call *continueGame()* which will display the next question or end the game
protocol GameDelegate {
    func continueGame(from viewController: UIViewController)
    func showFeedback(from viewController: UIViewController, correct: Bool)
}

