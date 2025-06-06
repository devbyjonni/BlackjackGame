import SwiftUI

struct GameView: View {
    @State private var game = GameManager()
    @State private var showGameStatus = false
    @State private var hasGameStarted = false

    private let scoreCircleSize: CGFloat = 35
    private let buttonWidth: CGFloat = 140
    private let buttonHeight: CGFloat = 55
    private let dealButtonWidth: CGFloat = 160
    private let messageDelay: Double = 0.8

    var body: some View {
        ZStack {
            VStack {
                scoreboardView()
                HandView(title: "Dealer", hand: game.dealerHand, gameOver: game.gameOver)
                HandView(title: "Player", hand: game.playerHand, gameOver: true)
                Spacer()
                actionButtons()
                Spacer()
            }

            GameStatusView(message: game.statusMessage, isVisible: $showGameStatus)

            if !hasGameStarted {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                    .transition(.opacity)

                VStack {
                    Text("♠️ Welcome to Blackjack")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom, 20)

                    Button(action: {
                        withAnimation {
                            hasGameStarted = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            game.startGame()
                        }
                    }) {
                        Text("Play")
                            .font(.title)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .transition(.scale)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Custom_Green"))
    }

    // MARK: - Scoreboard View

    private func scoreboardView() -> some View {
        VStack {
            Text("Scoreboard History")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .bold()
                .padding(.bottom, 2)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(game.scoreHistory.indices, id: \.self) { index in
                        let score = game.scoreHistory[index]
                        Text(score)
                            .font(.headline)
                            .bold()
                            .frame(width: scoreCircleSize, height: scoreCircleSize)
                            .background(["P", "BJ"].contains(score) ? Color.green : Color.red)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
            }
            .frame(height: 50)
            .background(Color.black.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 5)
    }

    // MARK: - Action Buttons

    @ViewBuilder
    private func actionButtons() -> some View {
        if !game.gameOver && !game.hideButtons {
            HStack(spacing: 20) {
                GameButton(title: "Hit") {
                    game.playerHit()
                    if game.gameOver {
                        showStatusThenReset()
                    }
                }
                .frame(width: buttonWidth, height: buttonHeight)

                GameButton(title: "Stand") {
                    game.playerStand {
                        showStatusThenReset()
                    }
                }
                .frame(width: buttonWidth, height: buttonHeight)
            }
            .padding(.top, 15)
        } else if game.gameOver {
            GameButton(title: "Deal") {
                game.startGame()
            }
            .frame(width: dealButtonWidth, height: buttonHeight)
        }
    }

    // MARK: - Status Message Flow

    private func showStatusThenReset() {
        showGameStatus = true
        DispatchQueue.main.asyncAfter(deadline: .now() + messageDelay) {
            showGameStatus = false
        }
    }
}
