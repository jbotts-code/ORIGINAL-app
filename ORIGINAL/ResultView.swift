//
//  ResultView.swift
//  ORIGINAL
//
//  Created by JONATHON BOTTS on 3/11/26.
//

import SwiftUI

struct QuoteResponse: Codable {
    let content: String
    let author: String
}

struct ResultView: View {
    let answers: [Int: String]
    @Binding var savedResults: [SavedResult]
    var onRestart: () -> Void

    @State private var visible = false
    @State private var quote: String = ""
    @State private var quoteAuthor: String = ""
    @State private var loadingQuote = true

    // Mood check-in
    @State private var userWord: String? = nil
    @State private var showEngagement = false
    @State private var decision: String? = nil
    @State private var showHistory = false

    let questions = Question.all
    let wordOptions = ["Present", "Curious", "Guarded", "Distant", "Searching", "Open"]

    var appWord: String { generateEngagementWord(from: answers) }

    var engagementMatch: Bool { userWord == appWord }

    var insightParagraph: String {
        switch (appWord, userWord ?? "") {
        case ("Present", _):
            return "You showed up openly — your answers reflect someone ready to connect. Trust that."
        case ("Curious", _):
            return "There's genuine interest here, even if it's still forming. Curiosity is a good place to start."
        case ("Guarded", _):
            return "You're protecting something. That's okay — but connection asks for a little risk."
        case ("Distant", _):
            return "You may not be in the right headspace right now. That's honest, and honesty matters."
        default:
            return "You're somewhere in between — still figuring it out. That's more human than you think."
        }
    }

    var body: some View {
        ZStack {
            Color(hex: "0A0A0A").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 8) {
                        Text("◦ complete ◦")
                            .font(.system(size: 9, weight: .regular, design: .monospaced))
                            .kerning(5)
                            .foregroundColor(Color(hex: "4B5563"))

                        Text("ORIGINAL")
                            .font(.system(size: 28, weight: .bold, design: .monospaced))
                            .kerning(8)
                            .foregroundColor(Color(hex: "F5F0E8"))

                        Text("you answered honestly.\nthat's already something.")
                            .font(.system(size: 12, weight: .light).italic())
                            .foregroundColor(Color(hex: "6B7280"))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.top, 4)
                    }
                    .padding(.top, 48)
                    .opacity(visible ? 1 : 0)
                    .animation(.easeOut(duration: 0.8), value: visible)

                    // API Quote
                    VStack(spacing: 6) {
                        if loadingQuote {
                            ProgressView()
                                .tint(Color(hex: "4B5563"))
                                .padding(.vertical, 20)
                        } else {
                            Text("\" \(quote) \"")
                                .font(.system(size: 11).italic())
                                .foregroundColor(Color(hex: "6B7280"))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .padding(.horizontal, 32)
                            Text("— \(quoteAuthor)")
                                .font(.system(size: 9, design: .monospaced))
                                .kerning(2)
                                .foregroundColor(Color(hex: "374151"))
                        }
                    }
                    .padding(.vertical, 24)
                    .opacity(visible ? 1 : 0)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: visible)

                    divider

                    // Answers list
                    VStack(alignment: .leading, spacing: 18) {
                        ForEach(questions) { q in
                            if let answer = answers[q.id] {
                                HStack(alignment: .top, spacing: 14) {
                                    Text(String(format: "%02d", q.id))
                                        .font(.system(size: 9, design: .monospaced))
                                        .kerning(2)
                                        .foregroundColor(Color(hex: "4B5563"))
                                        .padding(.top, 2)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(q.text)
                                            .font(.system(size: 10))
                                            .foregroundColor(Color(hex: "6B7280"))
                                            .lineSpacing(2)
                                        Text("→ \(answer)")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color(hex: "D1D5DB"))
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 20)
                    .opacity(visible ? 1 : 0)
                    .animation(.easeOut(duration: 0.8).delay(0.3), value: visible)

                    divider

                    // App generated word
                    VStack(spacing: 12) {
                        Text("based on your answers")
                            .font(.system(size: 9, design: .monospaced))
                            .kerning(3)
                            .foregroundColor(Color(hex: "4B5563"))

                        Text(appWord.uppercased())
                            .font(.system(size: 32, weight: .bold, design: .monospaced))
                            .kerning(6)
                            .foregroundColor(Color(hex: "F5F0E8"))

                        Text("how would you describe yourself right now?")
                            .font(.system(size: 10).italic())
                            .foregroundColor(Color(hex: "6B7280"))
                            .padding(.top, 8)

                        // Word picker
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                            ForEach(wordOptions, id: \.self) { word in
                                Button(action: {
                                    userWord = word
                                    withAnimation(.easeOut(duration: 0.4)) {
                                        showEngagement = true
                                    }
                                }) {
                                    Text(word)
                                        .font(.system(size: 10, design: .monospaced))
                                        .kerning(1)
                                        .foregroundColor(userWord == word ? .black : Color(hex: "9CA3AF"))
                                        .padding(.vertical, 8)
                                        .frame(maxWidth: .infinity)
                                        .background(userWord == word ? Color(hex: "F5F0E8") : Color(hex: "1F2937"))
                                        .cornerRadius(4)
                                }
                            }
                        }
                        .padding(.horizontal, 32)
                    }
                    .padding(.vertical, 20)
                    .opacity(visible ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.4), value: visible)

                    // Engagement result
                    if showEngagement, let userWord = userWord {
                        divider

                        VStack(spacing: 16) {
                            if engagementMatch {
                                // Visual meter
                                Text("alignment confirmed")
                                    .font(.system(size: 9, design: .monospaced))
                                    .kerning(3)
                                    .foregroundColor(Color(hex: "4B5563"))

                                EngagementMeter(word: appWord)

                                Text(appWord.uppercased())
                                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                                    .kerning(4)
                                    .foregroundColor(Color(hex: "F5F0E8"))

                                Text("you and the app see it the same way.")
                                    .font(.system(size: 11).italic())
                                    .foregroundColor(Color(hex: "6B7280"))

                            } else {
                                // Paragraph insight
                                Text("a different read")
                                    .font(.system(size: 9, design: .monospaced))
                                    .kerning(3)
                                    .foregroundColor(Color(hex: "4B5563"))

                                HStack(spacing: 16) {
                                    VStack(spacing: 4) {
                                        Text("app")
                                            .font(.system(size: 8, design: .monospaced))
                                            .foregroundColor(Color(hex: "4B5563"))
                                        Text(appWord.uppercased())
                                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                                            .foregroundColor(Color(hex: "9CA3AF"))
                                    }
                                    Text("≠")
                                        .foregroundColor(Color(hex: "4B5563"))
                                    VStack(spacing: 4) {
                                        Text("you")
                                            .font(.system(size: 8, design: .monospaced))
                                            .foregroundColor(Color(hex: "4B5563"))
                                        Text(userWord.uppercased())
                                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                                            .foregroundColor(Color(hex: "F5F0E8"))
                                    }
                                }

                                Text(insightParagraph)
                                    .font(.system(size: 11).italic())
                                    .foregroundColor(Color(hex: "6B7280"))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                                    .padding(.horizontal, 32)
                            }

                            // Stay or Leave
                            if decision == nil {
                                Text("based on this — what do you want to do?")
                                    .font(.system(size: 9, design: .monospaced))
                                    .kerning(2)
                                    .foregroundColor(Color(hex: "4B5563"))
                                    .padding(.top, 8)

                                HStack(spacing: 12) {
                                    DecisionButton(label: "Stay", color: Color(hex: "F5F0E8")) {
                                        withAnimation(.spring()) { decision = "Stay" }
                                        saveResult(userWord: userWord, decision: "Stay")
                                    }
                                    DecisionButton(label: "Leave", color: Color(hex: "374151")) {
                                        withAnimation(.spring()) { decision = "Leave" }
                                        saveResult(userWord: userWord, decision: "Leave")
                                    }
                                }
                                .padding(.horizontal, 32)
                            } else {
                                // Decision made
                                Text(decision == "Stay" ? "✦ staying present" : "◦ stepping away")
                                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                                    .kerning(4)
                                    .foregroundColor(decision == "Stay" ? Color(hex: "F5F0E8") : Color(hex: "4B5563"))
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding(.vertical, 20)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }

                    divider

                    // Past results list
                    if !savedResults.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("past sessions")
                                    .font(.system(size: 9, design: .monospaced))
                                    .kerning(3)
                                    .foregroundColor(Color(hex: "4B5563"))
                                Spacer()
                                Button(action: { withAnimation { showHistory.toggle() }}) {
                                    Text(showHistory ? "hide" : "show")
                                        .font(.system(size: 9, design: .monospaced))
                                        .kerning(2)
                                        .foregroundColor(Color(hex: "6B7280"))
                                }
                            }
                            .padding(.horizontal, 32)

                            if showHistory {
                                ForEach(savedResults) { result in
                                    HStack(spacing: 12) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(result.formattedDate)
                                                .font(.system(size: 9, design: .monospaced))
                                                .foregroundColor(Color(hex: "4B5563"))
                                            HStack(spacing: 8) {
                                                Text(result.appWord.uppercased())
                                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                                    .foregroundColor(Color(hex: "9CA3AF"))
                                                Text("→")
                                                    .foregroundColor(Color(hex: "4B5563"))
                                                Text(result.decision.uppercased())
                                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                                    .foregroundColor(Color(hex: "F5F0E8"))
                                            }
                                        }
                                        Spacer()
                                        Button(action: {
                                            withAnimation { savedResults.removeAll { $0.id == result.id } }
                                        }) {
                                            Image(systemName: "xmark")
                                                .font(.system(size: 10))
                                                .foregroundColor(Color(hex: "4B5563"))
                                                .padding(8)
                                                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(hex: "1F2937"), lineWidth: 1))
                                        }
                                    }
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 8)
                                    .background(Color(hex: "111111"))
                                }
                            }
                        }
                        .padding(.vertical, 16)
                    }

                    // Restart
                    Button(action: onRestart) {
                        Text("START OVER")
                            .font(.system(size: 9, weight: .regular, design: .monospaced))
                            .kerning(4)
                            .foregroundColor(Color(hex: "4B5563"))
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(hex: "1F2937"), lineWidth: 1))
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 48)
                    .opacity(visible ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.5), value: visible)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { visible = true }
            Task { await fetchQuote() }
        }
    }

    var divider: some View {
        Rectangle()
            .fill(Color(hex: "1F2937"))
            .frame(height: 1)
            .padding(.horizontal, 32)
            .padding(.vertical, 4)
    }

    func saveResult(userWord: String, decision: String) {
        let result = SavedResult(
            date: Date(),
            answers: answers,
            appWord: appWord,
            userWord: userWord,
            decision: decision
        )
        savedResults.insert(result, at: 0)
        showHistory = true
    }

    func fetchQuote() async {
        guard let url = URL(string: "https://api.quotable.io/random?tags=friendship|inspirational&maxLength=120") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(QuoteResponse.self, from: data)
            await MainActor.run {
                quote = decoded.content
                quoteAuthor = decoded.author
                loadingQuote = false
            }
        } catch {
            await MainActor.run {
                quote = "The quality of your presence determines the quality of your connection."
                quoteAuthor = "Original"
                loadingQuote = false
            }
        }
    }
}

// MARK: - Subviews

struct EngagementMeter: View {
    let word: String

    var level: CGFloat {
        switch word {
        case "Present": return 0.95
        case "Open":    return 0.85
        case "Curious": return 0.70
        case "Searching": return 0.50
        case "Guarded": return 0.30
        case "Distant": return 0.15
        default:        return 0.50
        }
    }

    var body: some View {
        VStack(spacing: 6) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(hex: "1F2937"))
                        .frame(height: 4)
                        .cornerRadius(2)
                    Rectangle()
                        .fill(Color(hex: "F5F0E8"))
                        .frame(width: geo.size.width * level, height: 4)
                        .cornerRadius(2)
                        .animation(.easeOut(duration: 1.0), value: level)
                }
            }
            .frame(height: 4)
            .padding(.horizontal, 32)

            HStack {
                Text("distant")
                    .font(.system(size: 8, design: .monospaced))
                    .foregroundColor(Color(hex: "4B5563"))
                Spacer()
                Text("present")
                    .font(.system(size: 8, design: .monospaced))
                    .foregroundColor(Color(hex: "4B5563"))
            }
            .padding(.horizontal, 32)
        }
    }
}

struct DecisionButton: View {
    let label: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label.uppercased())
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .kerning(3)
                .foregroundColor(label == "Stay" ? .black : Color(hex: "F5F0E8"))
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .background(color)
                .cornerRadius(4)
        }
    }
}

#Preview {
    ResultView(
        answers: [1: "Something real", 2: "Quality time", 3: "A starting point"],
        savedResults: .constant([]),
        onRestart: {}
    )
}
