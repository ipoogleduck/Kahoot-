//
//  SubjectTVC.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/9/21.
//

import UIKit

struct SubjectInfoStruct: Equatable {
    var name: String
    var icon: UIImage?
}

class SubjectTVC: UITableViewController {
    
    let editQustionsOption = SubjectInfoStruct(name: "Edit Questions", icon: UIImage(systemName: "list.bullet.rectangle"))
    let playGameOption = SubjectInfoStruct(name: "Play Game", icon: UIImage(systemName: "gamecontroller"))
    let viewScoreboardOption = SubjectInfoStruct(name: "View Scoreboard", icon: UIImage(systemName: "list.number"))
    let courseMaterialsOption = SubjectInfoStruct(name: "Course Materials", icon: UIImage(systemName: "tray.full"))
    
    var subjectOptions: [SubjectInfoStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = courses[selectedCourseIndex].name
        if isStudent {
            subjectOptions = [playGameOption, viewScoreboardOption, courseMaterialsOption]
        } else {
            subjectOptions = [editQustionsOption, viewScoreboardOption, courseMaterialsOption]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subjectOptions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell", for: indexPath) as! SubjectCell
        let subjectOption = subjectOptions[indexPath.row]
        cell.titleLabel.text = subjectOption.name
        cell.mainImage.image = subjectOption.icon ?? UIImage(systemName: "questionmark.circle")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = subjectOptions[indexPath.row]
        if selectedOption == editQustionsOption {
            
        } else if selectedOption == playGameOption {
            
        } else if selectedOption == viewScoreboardOption {
            performSegue(withIdentifier: "scoreboardSegue", sender: self)
        } else {
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

class SubjectCell: UITableViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
}