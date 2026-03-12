//
//  SplashView.swift
//  ORIGINAL
//
//  Created by JONATHON BOTTS on 3/11/26.
//

import SwiftUI

struct SplashView: View {
    var onDone: () -> Void

    @State private var showLabel    = false
    @State private var showTitle    = false
    @State private var showUnderline = false
    @State private var showSub      = false
    @State private var barProgress: CGFloat = 0

    var body: some View {
        ZStack {
            Color(hex: "F8F8F8").ignoresSafeArea()

            // Background grid
            GridLines()

            // Corner marks
            CornerMarks()

            // Scanning line
            ScanLine(triggered: showLabel)

            VStack(spacing: 0) {
                Spacer()

                // Init label
                Text("◦ initiating ◦")
                    .font(.system(size: 9, weight: .regular, design: .monospaced))
                    .kerning(6)
                    .foregroundColor(Color(hex: "9CA3AF"))
                    .textCase(.uppercase)
                    .opacity(showLabel ? 1 : 0)
                    .animation(.easeIn(duration: 0.6), value: showLabel)
                    .padding(.bottom, 20)

                // ORIGINAL title
                VStack(spacing: 0) {
                    Text("ORIGINAL")
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(hex: "0A0A0A"))
                        .kerning(10)
                        .opacity(showTitle ? 1 : 0)
                        .scaleEffect(x: showTitle ? 1 : 0.85, y: 1)
                        .animation(.easeOut(duration: 0.8), value: showTitle)

                    // Underline scan
                    GeometryReader { geo in
                        Rectangle()
                            .fill(Color(hex: "0A0A0A"))
                            .frame(width: showUnderline ? geo.size.width : 0, height: 1)
                            .animation(.easeOut(duration: 0.6), value: showUnderline)
                    }
                    .frame(height: 1)
                }

                // Subtitle
                Text("a different kind of question")
                    .font(.system(size: 10, weight: .regular, design: .monospaced))
                    .kerning(3)
                    .foregroundColor(Color(hex: "6B7280"))
                    .textCase(.uppercase)
                    .opacity(showSub ? 1 : 0)
                    .animation(.easeIn(duration: 0.6), value: showSub)
                    .padding(.top, 24)

                Spacer()
            }

            // Loading bar at bottom
            VStack {
                Spacer()
                VStack(spacing: 6) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color(hex: "E5E7EB"))
                                .frame(height: 1)
                            Rectangle()
                                .fill(Color(hex: "0A0A0A"))
                                .frame(width: geo.size.width * barProgress, height: 1)
                                .animation(.linear(duration: 2.2), value: barProgress)
                        }
                    }
                    .frame(height: 1)

                    HStack {
                        Text("SYS")
                            .font(.system(size: 8, design: .monospaced))
                            .kerning(2)
                            .foregroundColor(Color(hex: "D1D5DB"))
                        Spacer()
                        Text("LOADING")
                            .font(.system(size: 8, design: .monospaced))
                            .kerning(2)
                            .foregroundColor(Color(hex: "D1D5DB"))
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
            }
        }
        .onAppear { runSequence() }
    }

    func runSequence() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { showLabel = true; barProgress = 1.0 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { showTitle = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) { showUnderline = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { showSub = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.6) { onDone() }
    }
}

// MARK: - Subviews

struct GridLines: View {
    var body: some View {
        Canvas { ctx, size in
            let cols = 8, rows = 12
            for i in 1..<rows {
                let y = size.height * CGFloat(i) / CGFloat(rows)
                var p = Path(); p.move(to: CGPoint(x: 0, y: y)); p.addLine(to: CGPoint(x: size.width, y: y))
                ctx.stroke(p, with: .color(.black.opacity(0.04)), lineWidth: 0.5)
            }
            for i in 1..<cols {
                let x = size.width * CGFloat(i) / CGFloat(cols)
                var p = Path(); p.move(to: CGPoint(x: x, y: 0)); p.addLine(to: CGPoint(x: x, y: size.height))
                ctx.stroke(p, with: .color(.black.opacity(0.04)), lineWidth: 0.5)
            }
        }
        .ignoresSafeArea()
    }
}

struct CornerMarks: View {
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    CornerMark(corners: [.top, .left])
                    Spacer()
                    CornerMark(corners: [.top, .right])
                }
                Spacer()
                HStack {
                    CornerMark(corners: [.bottom, .left])
                    Spacer()
                    CornerMark(corners: [.bottom, .right])
                }
            }
            .padding(20)
        }
        .ignoresSafeArea()
    }
}

enum MarkEdge { case top, bottom, left, right }

struct CornerMark: View {
    let corners: [MarkEdge]
    var body: some View {
        Rectangle().fill(Color.clear)
            .frame(width: 16, height: 16)
            .overlay(
                ZStack {
                    if corners.contains(.top)    { Rectangle().fill(Color(hex: "1C1C1C").opacity(0.25)).frame(height: 1).frame(maxHeight: .infinity, alignment: .top) }
                    if corners.contains(.bottom) { Rectangle().fill(Color(hex: "1C1C1C").opacity(0.25)).frame(height: 1).frame(maxHeight: .infinity, alignment: .bottom) }
                    if corners.contains(.left)   { Rectangle().fill(Color(hex: "1C1C1C").opacity(0.25)).frame(width: 1).frame(maxWidth: .infinity, alignment: .leading) }
                    if corners.contains(.right)  { Rectangle().fill(Color(hex: "1C1C1C").opacity(0.25)).frame(width: 1).frame(maxWidth: .infinity, alignment: .trailing) }
                }
            )
    }
}

struct ScanLine: View {
    let triggered: Bool
    var body: some View {
        GeometryReader { geo in
            Rectangle()
                .fill(LinearGradient(colors: [.clear, Color.black.opacity(0.06), .clear], startPoint: .leading, endPoint: .trailing))
                .frame(height: 1)
                .offset(y: triggered ? geo.size.height : 0)
                .animation(.linear(duration: 2.5), value: triggered)
        }
        .ignoresSafeArea()
    }
}

#Preview { SplashView(onDone: {}) }
