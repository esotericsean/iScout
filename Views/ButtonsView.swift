import SwiftUI

struct ButtonsView: View {
    var onLocationTap: () -> Void
    var onAddTap: () -> Void
    
    var body: some View {
        HStack(spacing: 180) {
            Button(action: onLocationTap) {
                Image(systemName: "location.fill")
                    .font(.title2)
                    .foregroundColor(Color(AppearanceManager.accentColor))
                    .frame(width: 24, height: 24)
                    .padding(16)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            
            Button(action: onAddTap) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color(AppearanceManager.accentColor))
                    .frame(width: 24, height: 24)
                    .padding(16)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40)
    }
} 
