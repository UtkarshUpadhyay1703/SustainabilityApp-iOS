//
//  ProfileView.swift
//  SustainabilityApp
//
//  Created by Utkarsh Upadhyay on 02/11/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var selectedSegment: Segment = .performance
    // sample stats
    private let stats: [StatItem] = [
        StatItem(title: "Days", value: "1", iconName: "small_tree"),
        StatItem(title: "Points", value: "45", iconName: "xp_capital"),
        StatItem(title: "Seeds", value: "13", iconName: "seed")
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 18) {
                    HStack {
                        Image("shrShortLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 48)
                            .padding(.leading, 12)
                        Spacer()
                        Button(action: {
                            // settings action
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(#colorLiteral(red: 0.298, green: 0.286, blue: 0.463, alpha: 1)))
                                .padding(12)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
                        }
                        .padding(.trailing, 12)
                    }
                    .padding(.top, 12)
                    .background(.white)
                    .clipShape(Capsule())
                    
                    // Community header
                    HStack {
                        Text("Community")
                            .font(.title3.weight(.bold))
                            .foregroundColor(Color(#colorLiteral(red: 0.196, green: 0.219, blue: 0.341, alpha: 1)))
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 6)
                    
                    // ACTNOW card
                    HStack {
                        RoundedCard {
                            HStack {
                                Image("actnow")
                                    .resizable()
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(8)
                                Text("ACTNOW")
                                    .font(.headline)
                                    .foregroundColor(Color(#colorLiteral(red: 0.196, green: 0.219, blue: 0.341, alpha: 1)))
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                    
                    // Invitation code card
                    HStack {
                        Image("profile_invitation")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                            .padding(.leading, 6)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Do you have an invitation code?")
                                .font(.subheadline).bold()
                                .foregroundColor(Color(#colorLiteral(red: 0.196, green: 0.219, blue: 0.341, alpha: 1)))
                            Text("Enter it to unlock special content and receive rewards")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        Spacer()
                        // close button circle
                        Button(action: {
                            // dismiss invite card
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(Color(#colorLiteral(red: 0.196, green: 0.219, blue: 0.341, alpha: 1)))
                                .frame(width: 36, height: 36)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
                        }
                        .padding(6)
                    }
                    .padding(12)
                    .background(Color(#colorLiteral(red: 0.8642934561, green: 0.8990774751, blue: 0.9630581737, alpha: 1)))
                    .clipShape(RoundedCorner())
                    .padding(3)
                    .background(.white)
                    .clipShape(RoundedCorner())
                    .padding(.horizontal)
                    
                    HStack {
                        Picker("", selection: $selectedSegment) {                            ForEach(Segment.allCases) { segment in
                            Text(segment.rawValue).tag(segment)
                        }
                        }
                        .pickerStyle(.segmented)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    .padding(.top, 4)
                    
                    HStack(spacing: 12) {
                        ForEach(stats) { item in
                            StatCard(item: item)
                        }
                    }
                    .padding(.horizontal)
                    
                    RoundedCard {
                        HStack {
                            Image("gem")
                                .resizable()
                                .frame(width: 64, height: 64)
                            VStack(alignment: .leading, spacing: 8) {
                                Text("GEMS")
                                    .font(.subheadline)
                                Text("6")
                                    .font(.title2).bold()
                                    .foregroundColor(Color(#colorLiteral(red: 0.216, green: 0.243, blue: 0.36, alpha: 1)))
                            }
                            Spacer()
                            
                            Button(action: {
                                // marketplace tapped
                            }) {
                                Text("MARKETPLACE")
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 18)
                                    .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.039, green: 0.451, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.082, green: 0.611, blue: 1, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 90)
                }
                .padding(.vertical, 10)
            }
        }
        .background(Color(#colorLiteral(red: 0.964, green: 0.974, blue: 0.986, alpha: 1)).ignoresSafeArea())
    }
}

// MARK: - RoundedCard

struct RoundedCard<Content: View>: View {
    let content: () -> Content
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    var body: some View {
        content()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
                    .padding(3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(#colorLiteral(red: 0.8642934561, green: 0.8990774751, blue: 0.9630581737, alpha: 1)), lineWidth: 2)
            )
    }
}

// MARK: - SegmentButton

struct SegmentButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline).bold()
                .foregroundColor(isSelected ? .white : Color(.systemGray))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isSelected ? Color(#colorLiteral(red: 0.039, green: 0.451, blue: 1, alpha: 1)) : Color.white)
                .cornerRadius(22)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color(#colorLiteral(red: 0.906, green: 0.917, blue: 0.929, alpha: 1)), lineWidth: 1)
                )
        }
    }
}

// MARK: - StatCard

struct StatCard: View {
    let item: StatItem
    var body: some View {
        VStack(spacing: 8) {
            if let icon = item.iconName {
                Image(icon)
                    .font(.title)
                    .frame(maxHeight: 50)
                    .foregroundColor(Color.green)
                    .padding(.top, 8)
            }
            Text(item.value)
                .font(.title2).bold()
                .foregroundColor(Color(#colorLiteral(red: 0.216, green: 0.243, blue: 0.36, alpha: 1)))
            Text(item.title)
                .font(.subheadline).bold()
                .foregroundColor(.gray)
                .padding(.bottom, 8)
        }
        .frame(maxWidth: 150)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.02), radius: 6, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(#colorLiteral(red: 0.906, green: 0.917, blue: 0.929, alpha: 1)), lineWidth: 1)
        )
        .frame(height: 120)
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
                .foregroundColor(selected ? Color(#colorLiteral(red: 0.039, green: 0.451, blue: 1, alpha: 1)) : Color.gray)
            Text(title)
                .font(.caption2)
                .foregroundColor(selected ? Color(#colorLiteral(red: 0.039, green: 0.451, blue: 1, alpha: 1)) : Color.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProfileView()
}
