# 🃏 BlackjackGame

#### A simple and fun Blackjack game built with SwiftUI.

## Features

- Swift 6 with `@Observable` for state management
- Modular views: `GameView`, `HandView`, `Deck`, etc.
- Emoji-enhanced messages and clean game flow
- Scoreboard that tracks wins, losses, and Blackjacks 🎯
- Designed for learning and fun!

## Folder Structure

```
BlackjackGame/
├── BlackjackGame/
├── BlackjackGame.xcodeproj
├── README.md
└── .gitignore
```

## Code Overview

### Models

- `Card` – describes a playing card with suit, rank and value.
- `Deck` – creates and shuffles multiple decks, dealing cards as needed.
- `Hand` – represents a player's or dealer's hand and calculates its value.

### Views

- `GameView` – drives the gameplay and contains the action buttons and scoreboard.
- `HandView` – renders the player and dealer hands.
- `CardView` – displays a single card image.
- `GameStatusView` – shows temporary messages such as wins or busts.
- `GameActionButton` – a reusable button with a simple animation.

## Getting Started

Open `BlackjackGame.xcodeproj` in Xcode and build for iOS or macOS. The project
requires Swift 6 with the `@Observable` macro. When the app launches you'll see
the main game view and can start dealing cards right away. The scoreboard keeps
track of wins, losses and Blackjacks across rounds.
