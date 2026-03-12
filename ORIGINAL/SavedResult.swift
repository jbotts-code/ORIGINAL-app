//
//  SavedResult.swift
//  ORIGINAL
//
//  Created by JONATHON BOTTS on 3/11/26.
//

import Foundation

struct SavedResult: Identifiable {
    let id = UUID()
    let date: Date
    let answers: [Int: String]
    let appWord: String
    let userWord: String
    let decision: String
    
    var formattedDate: String {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        return f.string(from: date)
    }
}

// Generates engagement word from answers
func generateEngagementWord(from answers: [Int: String]) -> String {
    let openAnswers = [
        "Something real", "Quality time", "Deep conversations",
        "Exactly who I am", "Honesty", "Presence", "A starting point"
    ]
    let guardedAnswers = [
        "Something casual", "I'm not sure yet", "Almost nothing",
        "A little guarded", "Too in my head", "Avoid until it fades"
    ]
    
    var openScore = 0
    var guardedScore = 0
    
    for (_, answer) in answers {
        if openAnswers.contains(answer) { openScore += 1 }
        if guardedAnswers.contains(answer) { guardedScore += 1 }
    }
    
    if openScore >= 4 { return "Present" }
    else if openScore == 3 { return "Curious" }
    else if guardedScore >= 4 { return "Guarded" }
    else if guardedScore == 3 { return "Distant" }
    else { return "Searching" }
}
