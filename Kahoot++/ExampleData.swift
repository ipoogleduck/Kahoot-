//
//  ExampleData.swift
//  Kahoot++
//
//  Created by Oliver Elliott on 11/18/21.
//

import Foundation

let exampleCourses = [
    CoursesStruct(name: "Math 251", instructor: "Bob Marley", lessons: exampleLessons, leaderboard: exampleLeaderboard, questions: exampleQuestions),
    CoursesStruct(name: "Writing 121", instructor: "Yogurt Sauce", lessons: exampleLessons, leaderboard: exampleLeaderboard, questions: exampleQuestions),
    CoursesStruct(name: "Engineering 102", instructor: "Dr. Jennifer Parham-Mocello", lessons: exampleLessons, leaderboard: exampleLeaderboard, questions: exampleQuestions)
]

let exampleLessons = [
    LessonStruct(title: "Implicit Differentiation", text: "Read in OpenStax: The subsection of Section 2.4 titled \"Continuity over an Interval\" from example 2.35 through Theorem 2.10, then Theorem 2.10  - Continuity of Trigonometric Functions"),
    LessonStruct(title: "Trig and Exponential", text: "Read in OpenStax: The subsection of Section 2.4"),
]

let exampleLeaderboard = [
    LeaderboardStruct(id: "145345", name: "Oliver Bolliver", score: 56),
    LeaderboardStruct(id: "567843", name: "Joe Manly", score: 201),
    LeaderboardStruct(id: "435672", name: "Scott Johnson", score: 12),
    LeaderboardStruct(id: "087478", name: "Kevin Rossel", score: 35)
]

let exampleQuestions = [
    QuestionStruct(question: "Is 2+2 equal to 4?", type: .trueFalse, trueOrFalse: true, points: 10),
    QuestionStruct(question: "Ariel was playing basketball. 1 of her shots went in the hoop. 2 of her shots did not go in the hoop. How many shots were there in total?", type: .multipleChoice, multipleChoice: [MultipleChoice(answer: "2", correct: false), MultipleChoice(answer: "7", correct: false), MultipleChoice(answer: "6383", correct: false), MultipleChoice(answer: "3", correct: true)], points: 15),
    QuestionStruct(question: "Last hockey season, Jack scored g goals. Patrik scored twice as many goals than Jack. Write an expression that shows how many goals Patrik scored using f(x).", type: .textAnswer, textAnswer: ["f(x) = 2g", "f(x)=2g", "f(x)= 2g", "f(x) =2g"], points: 20),
]
