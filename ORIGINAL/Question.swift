//
//  Question.swift
//  ORIGINAL
//
//  Created by JONATHON BOTTS on 3/11/26.
//

import Foundation

struct Question: Identifiable {
    let id: Int
    let text: String
    let options: [String]
}

extension Question {
    static let all: [Question] = [
        Question(id: 1, text: "What are you actually looking for right now?",
                 options: ["Something real", "Something casual", "I'm not sure yet", "I'll know when I find it"]),
        Question(id: 2, text: "How do you show up when you care about someone?",
                 options: ["Quality time", "Small gestures", "Deep conversations", "Giving space"]),
        Question(id: 3, text: "What does a first impression mean to you?",
                 options: ["Everything", "A starting point", "Almost nothing", "Depends on the person"]),
        Question(id: 4, text: "When conflict comes up, you tend to...",
                 options: ["Address it directly", "Need time first", "Listen more than speak", "Avoid until it fades"]),
        Question(id: 5, text: "The version of you on a first date is...",
                 options: ["Exactly who I am", "A little guarded", "Too in my head", "Different every time"]),
        Question(id: 6, text: "What do you need most from a partner?",
                 options: ["Honesty", "Presence", "Independence", "Growth"]),
    ]
}
