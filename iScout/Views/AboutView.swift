import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image("profile") // Add your profile photo to assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                    .shadow(radius: 5)
                
                Text("Sean Duran")
                    .font(.title)
                    .bold()
                
                Text("iOS Developer")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("About Me")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    Text("I'm a passionate iOS developer focused on creating intuitive and useful applications. iScout is designed to help users discover and remember important locations.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                // Contact/Social Links
                VStack(spacing: 12) {
                    LinkButton(icon: "envelope.fill", text: "Email", url: "mailto:your.email@example.com")
                    LinkButton(icon: "link", text: "Website", url: "https://yourwebsite.com")
                    LinkButton(icon: "person.crop.circle", text: "GitHub", url: "https://github.com/yourusername")
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("About")
    }
}

struct LinkButton: View {
    let icon: String
    let text: String
    let url: String
    
    var body: some View {
        Button(action: {
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }) {
            HStack {
                Image(systemName: icon)
                Text(text)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
        }
    }
} 