//
//  LeaderboardTVC.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/9/21.
//

import UIKit

struct LeaderboardStruct: Codable {
    var id: String
    var name: String
    var score: Int
}

class LeaderboardTVC: UITableViewController {
    
    var leaderboard: [LeaderboardStruct]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leaderboard = leaderboard.sorted(by: {$0.score > $1.score}) //Sorts by highest score
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        leaderboard.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardCell
        let user = leaderboard[indexPath.row]
        let place = indexPath.row+1
        cell.leadingLabel.text = "\(place). \(user.name)"
        cell.trailingLabel.text = String(user.score)
        return cell
    }
    
}

class LeaderboardCell: UITableViewCell {
    
    @IBOutlet weak var leadingLabel: UILabel!
    @IBOutlet weak var trailingLabel: UILabel!
    
}
