//
//  FeedbackVC.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/16/21.
//

import UIKit

class FeedbackVC: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var secondaryLabel: UILabel!
    
    var delegate: GameDelegate?
    
    var question: String!
    var correct: Bool!
    var leaderboard: [LeaderboardStruct]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = question
        if correct {
            view.backgroundColor = UIColor(named: "DarkGreen")
            mainLabel.text = "Correct!"
            mainImage.image = UIImage(systemName: "checkmark.circle")
        } else {
            view.backgroundColor = .red
            mainLabel.text = "Nope, wrong"
            mainImage.image = UIImage(systemName: "xmark.circle")
        }
        let sorted = leaderboard.sorted(by: {$0.score > $1.score}) //Sorts by highest score
        if let index = sorted.firstIndex(where: {$0.id == id}) {
            let place = index+1
            let endingString = getEndingString(for: place)
            var secondLine = "Congrats!"
            if place != 1 { //if not in first place
                let placeAhead = sorted[index-1].name
                let pointsBehind = sorted[index-1].score-sorted[index].score
                var addS = ""
                if pointsBehind != 1 {
                    addS = "s"
                }
                secondLine = "\(pointsBehind) point\(addS) behind \(placeAhead)"
            }
            secondaryLabel.text = "You are in \(place)\(endingString) place\n\(secondLine)"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { //Delay
            self.delegate?.continueGame(from: self)
        }
    }
    
    func getEndingString(for number: Int) -> String { //Returning ending to place
        let last = String(number).last
        if last == "1" {
            return "st"
        } else if last == "2" {
            return "nd"
        } else if last == "3" {
            return "rd"
        } else {
            return "th"
        }
    }
    
}
