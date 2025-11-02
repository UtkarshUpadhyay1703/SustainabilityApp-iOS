//
//  Model.swift
//  SustainabilityApp
//
//  Created by Utkarsh Upadhyay on 31/10/25.
//

import Foundation

struct Activity: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let xp: Int
    let showDot: Bool
    let buttonTitle: String? // "ACTIVATE"
}

struct LeaderboardUser: Identifiable {
    let id = UUID()
    let rank: Int
    let avatarName: String
    let username: String
    let rewardXP: Int
    let points: Int
}

struct StatItem: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let iconName: String?
}


enum ViewPages: String, CaseIterable {
    case Home = "house.fill", Profile = "person.crop.circle", Mission = "flag.fill", Leaderboard = "trophy.fill"
}

enum Segment:String, CaseIterable, Identifiable {
    case performance = "PERFORMANCE", impact = "IMPACT"
    var id: String { self.rawValue }
}
