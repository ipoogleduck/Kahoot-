//
//  LeaderboardTVC.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/9/21.
//

import UIKit

struct LeaderboardStruct {
    var id: String
    var name: String
    var score: Int
}

let exampleLeaderboard = [
    LeaderboardStruct(id: "145345", name: "Oliver Bolliver", score: 56),
    LeaderboardStruct(id: "567843", name: "Joe Manly", score: 201),
    LeaderboardStruct(id: "435672", name: "Scott Johnson", score: 12),
    LeaderboardStruct(id: "087478", name: "Kevin Rossel", score: 35)
]

class LeaderboardTVC: UITableViewController {
    
    var allUsers = exampleLeaderboard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allUsers = allUsers.sorted(by: {$0.score > $1.score}) //Sorts by highest score
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardCell
        let user = allUsers[indexPath.row]
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
