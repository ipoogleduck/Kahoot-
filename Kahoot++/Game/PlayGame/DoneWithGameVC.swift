//
//  DoneWithGameVC.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/17/21.
//

import UIKit

class DoneWithGameVC: UIViewController {
    
    @IBOutlet var playAgainButton: UIButton!
    @IBOutlet var exitButton: UIButton!
    
    var leaderboard: [LeaderboardStruct]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func viewLeaderboardButton(_ sender: Any) {
        guard let leaderboardTVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "LeaderboardTVC") as? LeaderboardTVC else {
            fatalError("Unable to Instantiate View Controller")
        }
        leaderboardTVC.leaderboard = leaderboard
        present(leaderboardTVC, animated: true)
    }
    
    
    @IBAction func playAgainButton(_ sender: Any) {
        
    }
    
    @IBAction func exitButton(_ sender: Any) {
        
    }
    
}
