//
//  QuestionView.swift
//  ORIGINAL
//
//  Created by JONATHON BOTTS on 3/11/26.
//

import SwiftUI

struct QuestionsView: View {
    var onComplete: ([Int: String]) -> Void

    @State private var currentIndex = 0
    @State private var answers: [Int: String] = [:]
    @State private var selected: String? = nil
    @State private var transitioning = false

    let questions = Question.all

    var current: Question { questions[currentIndex] }
    var progress: CGFloat { CGFloat(currentIndex) / CGFloat(questions.count) }

    var body: some View {
        ZStack {
            Color(hex: "F8F8F8").ignoresSafeArea()
            GridLines()

            VStack(spacing: 0) {
                // Top bar
                HStack {
                    Text("ORIGINAL")
                        .font(.system(size: 9, weight: .regular, design: .monospaced))
                        .kerning(4)
                        .foregroundColor(Color(hex: "9CA3AF"))
                    Spacer()
                    Text("\(String(format: "%02d", currentIndex + 1)) / \(String(format: "%02d", questions.count))")
                        .font(.system(size: 9, weight: .regular, design: .monospaced))
                        .kerning(2)
                        .foregroundColor(Color(hex: "9CA3AF"))
                }
                .padding(.horizontal, 28)
                .padding(.top, 24)

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle().fill(Color(hex: "E5E7EB")).frame(height: 1)
                        Rectangle()
                            .fill(Color(hex: "0A0A0A"))
                            .frame(width: geo.size.width * progress, height: 1)
                            .animation(.easeOut(duration: 0.4), value: progress)
                    }
                }
                .frame(height: 1)
                .padding(.horizontal, 28)
                .padding(.top, 12)

                Spacer()

                // Question
                VStack(alignment: .leading, spacing: 16) {
                    Text("◦ question \(String(format: "%02d", currentIndex + 1))")
                        .font(.system(size: 9, weight: .regular, design: .monospaced))
                        .kerning(4)
                        .foregroundColor(Color(hex: "9CA3AF"))

                    Text(current.text)
                        .font(.system(size: 22, weight: .semibold, design: .default))
                        .foregroundColor(Color(hex: "0A0A0A"))
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 28)
                .opacity(transitioning ? 0 : 1)
                .animation(.easeOut(duration: 0.3), value: transitioning)

                Spacer()

                // Options
                VStack(spacing: 10) {
                    ForEach(Array(current.options.enumerated()), id: \.offset) { i, option in
                        OptionButton(
                            label: String(UnicodeScalar(65 + i)!),
                            text: option,
                            isSelected: selected == option
                        ) {
                            choose(option)
                        }
                    }
                }
                .padding(.horizontal, 28)
                .opacity(transitioning ? 0 : 1)
                .animation(.easeOut(duration: 0.3), value: transitioning)

                // Bottom dots
                HStack(spacing: 5) {
                    ForEach(0..<questions.count, id: \.self) { i in
                        Circle()
                            .fill(i <= currentIndex ? Color(hex: "0A0A0A") : Color(hex: "E5E7EB"))
                            .frame(width: 4, height: 4)
                            .animation(.easeOut(duration: 0.3), value: currentIndex)
                    }
                }
                .padding(.top, 24)
                .padding(.bottom, 40)

                Text("tap to select")
                    .font(.system(size: 8, design: .monospaced))
                    .kerning(3)
                    .foregroundColor(Color(hex: "D1D5DB"))
                    .textCase(.uppercase)
                    .padding(.bottom, 32)
            }
        }
    }

    func choose(_ option: String) {
        guard !transitioning else { return }
        selected = option
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            transitioning = true
            answers[current.id] = option
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if currentIndex < questions.count - 1 {
                    currentIndex += 1
                    selected = nil
                    transitioning = false
                } else {
                    onComplete(answers)
                }
            }
        }
    }
}

struct OptionButton: View {
    let label: String
    let text: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Text(label)
                    .font(.system(size: 9, weight: .regular, design: .monospaced))
                    .kerning(2)
                    .foregroundColor(isSelected ? Color(hex: "666666") : Color(hex: "C4C4C4"))
                    .frame(width: 20)

                Text(text)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(isSelected ? .white : Color(hex: "374151"))

                Spacer()
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(isSelected ? Color(hex: "0A0A0A") : Color.white)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isSelected ? Color(hex: "0A0A0A") : Color(hex: "E5E7EB"), lineWidth: 1)
            )
            .shadow(color: .black.opacity(isSelected ? 0 : 0.03), radius: 4)
            .animation(.easeOut(duration: 0.2), value: isSelected)
        }
    }
}

#Preview { QuestionsView(onComplete: { _ in }) }
