import SwiftUI

struct SplashView: View {
    @Binding var showingSplash: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "map.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Welcome to iScout")
                .font(.largeTitle)
                .bold()
            
            Text("Scout and save your favorite locations")
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 15) {
                FeatureRow(icon: "mappin.circle.fill", text: "Save locations with custom details")
                FeatureRow(icon: "tag.fill", text: "Add tags to organize your spots")
                FeatureRow(icon: "photo.fill", text: "Include photos of your locations")
                FeatureRow(icon: "arrow.triangle.turn.up.right.diamond.fill", text: "Get directions anytime")
            }
            .padding(.vertical)
            
            Button(action: {
                withAnimation {
                    showingSplash = false
                    UserDefaults.standard.set(true, forKey: "hasSeenSplash")
                }
            }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.top)
        }
        .padding()
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            Text(text)
                .font(.body)
        }
    }
} 
