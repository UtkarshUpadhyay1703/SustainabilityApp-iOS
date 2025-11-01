//
//  DashboardView.swift
//  SustainabilityApp
//
//  Created by Utkarsh Upadhyay on 31/10/25.
//

import SwiftUI

struct DashboardView: View {
    private let activities: [Activity] = [
        Activity(title: "Stories", imageName: "activity_stories", xp: 20, showDot: true, buttonTitle: nil),
        Activity(title: "Quiz", imageName: "activity_quiz", xp: 10, showDot: true, buttonTitle: nil),
        Activity(title: "Mobility", imageName: "activity_mobility", xp: 0, showDot: false, buttonTitle: nil),
        Activity(title: "Wellness", imageName: "activity_wellness", xp: 0, showDot: false, buttonTitle: "ACTIVATE"),
        Activity(title: "Routine", imageName: "activity_routine", xp: 5, showDot: true, buttonTitle: nil),
        Activity(title: "Invite", imageName: "activity_invite", xp: 200, showDot: false, buttonTitle: nil),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    HeaderView()
                        .padding(.horizontal)
                        .padding(.top, 6)
                    
                    StreakCardView()
                        .padding(.horizontal)
                    
                    Text("Today's activities")
                        .font(.title3.weight(.bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(activities) { activity in
                            ActivityCard(activity: activity)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 60)
                }
                .padding(.top, 8)
            }
            .navigationBarHidden(true)
            .background(Color(#colorLiteral(red: 0.964, green: 0.974, blue: 0.986, alpha: 1)).edgesIgnoringSafeArea(.all))
            .overlay(BottomTabView(), alignment: .bottom)
        }
    }}

struct HeaderView: View {
    var body: some View {
        VStack(spacing: 14) {
            HStack(spacing: 10) {
                Spacer()
                HStack(spacing: 10) {
                    BadgeChip(icon: "leaf.fill", title: "15")
                    BadgeChip(icon: "trophy", title: "0")
                    BadgeChip(icon: "gift.fill", title: "3")
                }
            }
            .padding()
            
            VStack {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.12))
                            .frame(width: 72, height: 72)
                        Image("mascot")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Complete an activity and\nstart with the right Streak!")
                            .foregroundStyle(.white)
                            .font(.headline)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    // start action
                }) {
                    Text("START")
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 22)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(LinearGradient(colors: [Color(red: 1, green: 0.47, blue: 0.56), Color(red: 1, green: 0.47, blue: 0.56).opacity(0.9)], startPoint: .top, endPoint: .bottom))
                        )
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 14)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.054, green: 0.478, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.063, green: 0.678, blue: 0.996, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .clipShape(RoundedCorner(radius: 24, corners: [.bottomLeft, .bottomRight]))
        )
    }
}


struct BadgeChip: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font((.subheadline))
                .foregroundStyle(.white)
            Text(title)
                .foregroundStyle(.white)
                .font(.subheadline).bold()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(Color.white.opacity(0.12))
        .clipShape(Capsule())
    }
}

// MARK: - StreakCardView

struct StreakCardView: View {
    private let weekdays = ["Tue", "Wed", "Thu", "Fri", "Sat", "Sun", "Mon"]
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "leaf.circle.fill")
                    .font(.title)
                    .foregroundStyle(Color.green)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Active your Streak!")
                        .font(.headline)
                    Text("Come back every day to increase your Streak days!")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            HStack(spacing: 12) {
                ForEach(weekdays.indices, id: \.self) { index in
                    VStack(spacing: 6) {
                        Text(weekdays[index])
                            .font(.caption)
                            .foregroundStyle(index == 0 ? Color.blue : Color(.label))
                        Circle()
                            .strokeBorder(index == 0 ? Color.blue : Color(.tertiaryLabel), lineWidth: 2)
                            .background(Circle().fill(Color.gray).opacity(0.2))
                            .frame(width: 28, height: 28)
                    }
                }
            }
            .padding(.bottom, 12)
            .padding(.horizontal)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(#colorLiteral(red: 0.871, green: 0.890, blue: 0.902, alpha: 1)), lineWidth: 1)
        )
    }
}

// MARK: - ActivityCard

struct ActivityCard: View {
    let activity: Activity
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 4)
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color(#colorLiteral(red: 0.905, green: 0.915, blue: 0.925, alpha: 1)), lineWidth: 1))
                .frame(height: 140)
            
            VStack {
                HStack {
                    HStack(spacing: 10) {
                        Circle().fill(Color(.systemGray6)).frame(width: 34, height: 34)
                            .overlay(
                                Image(systemName: "book.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(Color(.systemBlue))
                            )
                        Text(activity.title)
                            .font(.headline)
                            .foregroundStyle(Color(#colorLiteral(red: 0.196, green: 0.219, blue: 0.341, alpha: 1)))
                    }
                    Spacer()
                    if activity.showDot {
                        Circle().fill(Color.red).frame(width: 12, height: 12)
                    }
                }
                .padding()
                
                Spacer()
                
                HStack {
                    Image(activity.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 60)
                        .clipped()
                        .offset(x: -6, y: 4)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                .overlay {
                    HStack {
                        if let buttonTitle = activity.buttonTitle {
                            Button(action: {}) {
                                Text(buttonTitle)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 18)
                                    .background(RoundedRectangle(cornerRadius: 20).fill(LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 0.47, blue: 0.56), Color(red: 1, green: 0.6, blue: 0.6)]), startPoint: .top, endPoint: .bottom)))
                                    .foregroundStyle(.white)
                            }
                        } else {
                            XPBadge(xp: activity.xp)
                        }
                    }
                }
            }
            .frame(height: 140)
        }
    }
}

// MARK: - XPBadge

struct XPBadge: View {
    let xp: Int
    var body: some View {
        HStack(spacing: 8) {
            HStack {
                Text("+\(xp)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("XP")
                    .font(.system(.callout))
            }
            
            Image(systemName: "arrow.forward")
                .foregroundStyle(.blue)
                .background(Circle())
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(RoundedRectangle(cornerRadius: 18).fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)), Color(#colorLiteral(red: 0.082, green: 0.611, blue: 1, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)))
        .foregroundStyle(.white)
        .shadow(radius: 2)
    }
}

// MARK: - BottomTabView (preview-only)

struct BottomTabView: View {
    var body: some View {
        HStack(spacing: 0) {
            TabItem(icon: "house.fill", title: "HOME", selected: true)
            TabItem(icon: "flag.fill", title: "MISSIONS", selected: false)
            TabItem(icon: "trophy.fill", title: "LEADERBOARD", selected: false)
            TabItem(icon: "person.crop.circle", title: "PROFILE", selected: false)
        }
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 4)
        )
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}

struct TabItem: View {
    let icon: String
    let title: String
    let selected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(selected ? Color.blue : Color.gray)
            Text(title)
                .font(.caption2)
                .foregroundStyle(selected ? Color.blue : Color.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - RoundedCorner helper

struct RoundedCorner: Shape {
    var radius: CGFloat = 12.0
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                               byRoundingCorners: corners,
                               cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


#Preview {
    DashboardView()
}
