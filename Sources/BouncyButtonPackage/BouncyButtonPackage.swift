// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct BouncyButton: View {
    private let title: String
    private let action: () -> Void
    
    @State private var isPressed = false
    @State private var pendingButtonAction: DispatchWorkItem?
    
    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        Button {
            bounce()
        } label: {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
//                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.accentColor)
                )
                .scaleEffect(isPressed ? 0.9 : 1.05)  // Bounce effect
                .animation(.spring(response: 0.25, dampingFraction: 0.45), value: isPressed)
        }
        .buttonStyle(.plain)
    }
    
    private func bounce() {
        isPressed = true
        pendingButtonAction?.cancel()
        
        let currentItem = DispatchWorkItem {
            self.isPressed = false
            self.action()
        }
        
        pendingButtonAction = currentItem
        
         DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: currentItem)
    }
}
