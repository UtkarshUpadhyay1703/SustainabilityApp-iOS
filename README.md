# SustainabilityApp – iOS

SustainabilityApp is an iOS prototype designed to encourage users to make sustainable lifestyle choices.
The app helps users track their eco-friendly actions, monitor CO₂ savings, compare performance with friends, and view insights on sustainable habits — all built using SwiftUI, MVVM, and async/await.

## Features
### Core App Flows:

Login / Signup — mock authentication using local model or in-memory validation
Feed Screen — displays sustainability posts with Like and Comment options
Map View — shows nearby active friends (mock coordinates using Google Maps placeholder)
Leaderboard — ranks users by sustainability scores using mock data
Report / Dashboard — visualizes weekly/monthly CO₂ savings and transport data using Swift Charts
Chatbot Interaction — basic text-based chatbot that provides eco-tips and motivation
Profile / Settings — lets users update personal details and preferences

### Architecture:

The app follows the MVVM (Model–View–ViewModel) pattern for clarity, maintainability, and testability.

SustainabilityApp/
 => Models/
 => ViewModels/
 => Views/

 ### Testing:

Unit tests validate ViewModel logic and Service layer behavior.
Example Test Cases:
Fetching feed posts asynchronously
Verifying state updates after liking a post
Mock service behavior for empty/error cases

Unit tests are implemented with XCTest. An in-memory SwiftData container is used to test persistence safely. Business logic (filters, search) is tested through the ViewModel.

## Requirements
iOS 17+ Xcode 15+ Swift 5.9+

## Limitations

Firebase backend not connected — mock data used.
Map pins and chat responses are sample data.
Data not persisted between sessions.
Chatbot is rule-based, not ML-driven.
These can be extended easily using Firebase Realtime Database and Auth.

## Future Enhancements

Full Firebase integration for authentication and database
Real-time updates via Combine or Firestore listeners
Enhanced chatbot using CoreML or OpenAI API
Notifications for eco-challenges or friend milestones
Offline caching and dark mode analytics

## How to Run
Clone the repo: git clone https://github.com/UtkarshUpadhyay1703/SustainabilityApp-iOS Open in Xcode. Run on Simulator or physical iPhone.
