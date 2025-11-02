//
//  ChatbotView.swift
//  SustainabilityApp
//
//  Created by Utkarsh Upadhyay on 02/11/25.
//

import SwiftUI

struct ChatbotView: View {
    @StateObject var viewModel: ChatViewModel
    @Namespace private var bottomID
    
    // Use init to accept a pre-initialized viewModel from outside
    init(viewModel: ChatViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: {
                    viewModel.clearHistory()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                        .foregroundColor(Color(#colorLiteral(red: 0.196, green: 0.219, blue: 0.341, alpha: 1)))
                        .padding(12)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // messages
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageRow(message: message)
                                .id(message.id)
                                .padding(.horizontal)
                        }
                                                
                        if viewModel.isTyping {
                            TypingIndicator()
                                .padding(.horizontal)
                                .id("typing")
                        }
                        
                        Color.clear.frame(height: 8).id(bottomID)
                        Spacer()
                    }
                    .padding(.top, 12)
                }
                .background(Color(#colorLiteral(red: 0.964, green: 0.974, blue: 0.986, alpha: 1)))
                .onChange(of: viewModel.messages.count) { oldValue, newValue in
                    if let last = viewModel.messages.last {
                        withAnimation(.easeOut(duration: 0.25)) {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    } else {
                        withAnimation { proxy.scrollTo(bottomID) }
                    }
                }
                .onChange(of: viewModel.isTyping) { oldValue, newValue in
                    if newValue { withAnimation { proxy.scrollTo("typing", anchor: .bottom) } }
                }
            }
            Spacer()
            // input bar
            HStack(spacing: 12) {
                TextField("Scrivi un messaggio...", text: $viewModel.inputText)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(LinearGradient(colors: [Color(#colorLiteral(red: 0.039, green: 0.451, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.082, green: 0.611, blue: 1, alpha: 1))], startPoint: .leading,
                                                   endPoint: .trailing), lineWidth: 2)
                    )
                    .background(RoundedRectangle(cornerRadius: 30).fill(Color.white))
                    .cornerRadius(30)
                
                Button(action: {
                    viewModel.send()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(#colorLiteral(red: 0.925, green: 0.941, blue: 0.961, alpha: 1)))
                            .frame(width: 48, height: 48)
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(Color(#colorLiteral(red: 0.039, green: 0.451, blue: 1, alpha: 1)))
                    }
                }
                .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .opacity(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.white.shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: -2))
        }
        .background(Color(#colorLiteral(red: 0.964, green: 0.974, blue: 0.986, alpha: 1)).ignoresSafeArea())
    }
}

// MARK: - Subviews

struct MessageRow: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isBot {
                // bot bubble (left)
                HStack(alignment: .bottom, spacing: 12) {
                    // small avatar
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                        .overlay(Image("mascot").resizable().scaledToFit().frame(width: 30, height: 30))
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(message.text)
                            .font(.body)
                            .foregroundColor(Color(#colorLiteral(red: 0.196, green: 0.219, blue: 0.341, alpha: 1)))
                            .padding(14)
                            .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(#colorLiteral(red: 0.906, green: 0.917, blue: 0.929, alpha: 1)), lineWidth: 1))
                        
                        Text("Ora")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                // user bubble (right)
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Text(message.text)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(14)
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color(#colorLiteral(red: 0.039, green: 0.451, blue: 1, alpha: 1))))
                        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                    
                    Text("Ora")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}

struct TypingIndicator: View {
    var body: some View {
        HStack {
            Spacer()

            Circle().fill(Color.white).frame(width: 40, height: 40)
                .overlay(Image("mascot").resizable().scaledToFit().frame(width: 30, height: 30))
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .frame(height: 46)
                .overlay(
                    HStack(spacing: 6) {
                        ForEach(0..<3) { i in
                            Circle()
                                .fill(Color.gray.opacity(0.6))
                                .frame(width: 6, height: 6)
                                .scaleEffect(1.0)
                                .opacity(0.9)
                                .animation(Animation.easeInOut.delay(Double(i) * 0.15).repeatForever(autoreverses: true), value: UUID())
                        }
                    }
                )
            Spacer()
        }
    }
}

#Preview {
    let vm = ChatViewModel(service: MockChatService())
    ChatbotView(viewModel: vm)
}

