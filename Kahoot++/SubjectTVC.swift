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

class SubjectTVC: UITableViewController, saveMaterialDelegate, saveQuestionsDelegate {
    
    let editQustionsOption = SubjectInfoStruct(name: "Edit Questions", icon: UIImage(systemName: "list.bullet.rectangle"))
    let playGameOption = SubjectInfoStruct(name: "Play Game", icon: UIImage(systemName: "gamecontroller"))
    let viewScoreboardOption = SubjectInfoStruct(name: "View Scoreboard", icon: UIImage(systemName: "list.number"))
    let courseMaterialsOption = SubjectInfoStruct(name: "Course Materials", icon: UIImage(systemName: "tray.full"))
    
    var subjectOptions: [SubjectInfoStruct] = []
    
    var delegate: saveCourseDelegate?
    var course: CoursesStruct!
    
    var currentQuestionIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = course.name
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
            guard let editQuestionsTVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "EditQuestionsTVC") as? EditQuestionsTVC else {
                fatalError("Unable to Instantiate View Controller")
            }
            editQuestionsTVC.delegate = self
            editQuestionsTVC.questions = course.questions
            navigationController?.pushViewController(editQuestionsTVC, animated: true)
        } else if selectedOption == playGameOption {
            currentQuestionIndex = 0
            startGame(from: self)
        } else if selectedOption == viewScoreboardOption {
            guard let leaderboardTVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "LeaderboardTVC") as? LeaderboardTVC else {
                fatalError("Unable to Instantiate View Controller")
            }
            leaderboardTVC.leaderboard = course.leaderboard
            navigationController?.pushViewController(leaderboardTVC, animated: true)
        } else {
            guard let materialsTVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MaterialsTVC") as? MaterialsTVC else {
                fatalError("Unable to Instantiate View Controller")
            }
            materialsTVC.delegate = self
            materialsTVC.lessons = course.lessons
            navigationController?.pushViewController(materialsTVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func save(lessons: [LessonStruct]) {
        course.lessons = lessons
        delegate?.save(course: course)
    }
    
    func save(questions: [QuestionStruct]) {
        course.questions = questions
        delegate?.save(course: course)
    }
    
}

protocol saveCourseDelegate {
    func save(course: CoursesStruct)
}

class SubjectCell: UITableViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
}
