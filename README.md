# BlackjackGame

A simple and fun Blackjack game built with SwiftUI. Designed to explore animation, state management, and modular view structure using the latest Swift 6 features.

## Features

- Swift 6 using the new `@Observable` macro
- Flip animations using `rotation3DEffect`
- Clean card dealing and collapsing flow
- Modular components (Cards, Views, Buttons)
- Dev Menu with adjustable animation speed and simulation buttons
- Scoreboard that tracks wins, losses, and Blackjacks

## Folder Structure

```
BlackjackGame/
├── BlackjackGame/
│   ├── App/
│   │   └── BlackjackGameApp.swift
│   ├── Managers/
│   │   └── GameManager.swift
│   ├── Models/
│   │   ├── Card.swift
│   │   ├── Deck.swift
│   │   └── Hand.swift
│   ├── Views/
│   │   ├── Buttons/
│   │   │   └── GameButton.swift
│   │   ├── DevMenu/
│   │   │   ├── DevMenu.swift
│   │   │   ├── SegmentedControlView.swift
│   │   │   └── AnimationSpeed.swift
│   │   ├── CenteredCardStackView.swift
│   │   ├── FlipCardView.swift
│   │   ├── GameStatusView.swift
│   │   ├── HandView.swift
│   │   ├── CardView.swift
│   │   ├── GameView.swift
├── BlackjackGame.xcodeproj
├── README.md
└── .gitignore
```

## Code Overview

### Models

- `Card`: Describes a card with suit, rank, and value
- `Deck`: Generates and shuffles one or more decks
- `Hand`: Calculates total hand value and Blackjack logic

### Views

- `GameView`: Main game screen using card stacks and animations
- `HandView`: Renders hands with logic-based overlap
- `CardView`: Single card view (front or back)
- `FlipCardView`: Card with 3D flip animation
- `CenteredCardStackView`: For overlapping dealer or player cards
- `GameStatusView`: Shows round result messages

### Dev Tools

- `DevMenu`: Floating menu with debug actions and animation speed control
- `SegmentedControlView`: Custom segment control for dev settings
- `AnimationSpeed`: Enum to control delay and speed globally
