//
//  LeaderboardView.swift
//  SustainabilityApp
//
//  Created by Utkarsh Upadhyay on 01/11/25.
//

import SwiftUI

struct LeaderboardView: View {
    // sample data
    private let users: [LeaderboardUser] = [
        .init(rank: 1, avatarName: "avatar_tiger", username: "ksiyabi4", rewardXP: 20, points: 0),
        .init(rank: 2, avatarName: "avatar_koala", username: "sgsbpijd-64225d", rewardXP: 20, points: 0),
        .init(rank: 3, avatarName: "avatar_koala", username: "ihmgvgsg-663b57", rewardXP: 20, points: 0),
        .init(rank: 4, avatarName: "avatar_color", username: "cristina-1e51cb", rewardXP: 20, points: 0),
        .init(rank: 5, avatarName: "avatar_color", username: "zohaib-046018", rewardXP: 20, points: 0),
    ]
    
    var body: some View {
        VStack(spacing: 18) {
            // Header gradient card
            HeaderLeagueView()
                .padding(.horizontal)
                .padding(.top, 8)
            
            // Leaderboard list card
            VStack(spacing: 0) {
                HStack {
                    Text("Position")
                        .font(.subheadline)
                        .foregroundColor(Color(#colorLiteral(red: 0.545, green: 0.564, blue: 0.6, alpha: 1)))
                    Spacer()
                    Text("Points")
                        .font(.subheadline)
                        .foregroundColor(Color(#colorLiteral(red: 0.545, green: 0.564, blue: 0.6, alpha: 1)))
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                
            ForEach(users) { user in
                    LeaderRowView(user: user)
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                    Divider().opacity(0.08)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(#colorLiteral(red: 0.882, green: 0.892, blue: 0.902, alpha: 1)), lineWidth: 1)
            )
            .padding(.horizontal)
            .shadow(color: Color.black.opacity(0.02), radius: 6, x: 0, y: 4)
            Spacer()
        }    }
}

// MARK: - HeaderLeagueView

struct HeaderLeagueView: View {
    var body: some View {
        VStack(spacing: 14) {
            HStack(spacing: 12) {
                Spacer()
                BadgeChip(icon: "leaf.fill", title: "15")
                BadgeChip(icon: "trophy", title: "0")
                BadgeChip(icon: "gift.fill", title: "3")
            }
            .padding()
            
            HStack(spacing: 18) {
                Circle()
                    .fill(Color(.systemBackground))
                    .frame(width: 56, height: 56)
                    .overlay(Image("badge_seed").resizable().scaledToFit().frame(width: 40, height: 40))
                
                ForEach(0..<4) { _ in
                    Circle()
                        .fill(Color(#colorLiteral(red: 0.941, green: 0.957, blue: 0.969, alpha: 1)))
                        .frame(width: 46, height: 46)
                        .overlay(Image(systemName: "lock.fill").foregroundColor(Color(#colorLiteral(red: 0.345, green: 0.345, blue: 0.47, alpha: 1))))
                }
                Spacer()
            }
            
            VStack(spacing: 6) {
                Text("Determined Seed")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("The top 7 advance to the next League")
                    .foregroundColor(Color.white.opacity(0.9))
                HStack(spacing: 8) {
                    Text("How does it work?")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Image(systemName: "info.circle")
                        .foregroundColor(.white)
                }
                
                HStack {
                    Spacer()
                    HStack(spacing: 8) {
                        Image(systemName: "timer")
                        Text("05D 15h")
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.white)
                    .clipShape(Capsule())
                    Spacer()
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
        }
        .padding(.vertical)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(LinearGradient(colors: [Color(#colorLiteral(red: 0.054, green: 0.478, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.082, green: 0.611, blue: 1, alpha: 1))], startPoint: .top, endPoint: .bottom))
        )
    }
}

// MARK: - LeaderRowView

struct LeaderRowView: View {
    let user: LeaderboardUser
    
    var body: some View {
        HStack(spacing: 12) {
            Text("\(user.rank)")
                .font(.title3.weight(.bold))
                .foregroundColor(Color(#colorLiteral(red: 0.216, green: 0.243, blue: 0.36, alpha: 1)))
                .frame(width: 40)
            
            HStack(spacing: 12) {
                Image(user.avatarName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(user.username)
                            .font(.headline)
                            .foregroundColor(Color(#colorLiteral(red: 0.216, green: 0.243, blue: 0.36, alpha: 1)))
                        Image(systemName: "sparkles")
                            .font(.caption)
                            .foregroundColor(Color.green)
                    }
                    
                    HStack(spacing: 10) {
                        HStack(spacing: 6) {
                            Image(systemName: "leaf.fill")
                                .font(.caption)
                                .foregroundColor(Color.green)
                            Text("+\(user.rewardXP)")
                                .font(.subheadline)
                                .foregroundColor(Color(#colorLiteral(red: 0.062, green: 0.431, blue: 1, alpha: 1)))
                        }
                        
                        Button(action: {
                            // follow action
                        }) {
                            Text("Follow")
                                .font(.subheadline)
                                .foregroundColor(Color(#colorLiteral(red: 0.062, green: 0.431, blue: 1, alpha: 1)))
                        }
                    }
                }
            }
            Spacer()
            
            Text("\(user.points) XP")
                .font(.headline)
                .foregroundColor(Color(#colorLiteral(red: 0.216, green: 0.243, blue: 0.36, alpha: 1)))
                .padding(.trailing, 6)
        }
    }
}

#Preview {
    LeaderboardView()
}
