//
//  ContentView.swift
//  ORIGINAL
//
//  Created by JONATHON BOTTS on 3/11/26.
//

import SwiftUI

enum ORIGINALScreen {
    case splash, questions, result
}

struct ContentView: View {
    @State private var screen: ORIGINALScreen = .splash
    @State private var answers: [Int: String] = [:]
    @State private var fading = false
    @State private var savedResults: [SavedResult] = []

    var body: some View {
        ZStack {
            switch screen {
            case .splash:
                SplashView {
                    transition { screen = .questions }
                }
            case .questions:
                QuestionsView(onComplete: { finalAnswers in
                    answers = finalAnswers
                    transition { screen = .result }
                })
            case .result:
                ResultView(
                    answers: answers,
                    savedResults: $savedResults,
                    onRestart: {
                        transition { screen = .splash; answers = [:] }
                    }
                )
            }
        }
        .opacity(fading ? 0 : 1)
        .animation(.easeInOut(duration: 0.6), value: fading)
    }

    func transition(_ action: @escaping () -> Void) {
        fading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            action()
            fading = false
        }
    }
}

#Preview { ContentView() }
