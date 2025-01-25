import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile section
                Image("profile")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                    .shadow(radius: 5)
                    .padding(.top, safeAreaInsets.top + 20)  // Add top padding
                
                Text("Made by")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Text("Sean Duran")
                    .font(.title)
                    .bold()
                
                // About section
                VStack(alignment: .leading, spacing: 15) {
                    Text("About Me")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    Text("Hi, I'm esotericsean/esotericmods. I'm a YouTuber and game developer. I love Game Boys, dogs, my wife, and my kids. Feel free to say hi and let me know if you guys have any issues with this app! :)")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width - 40)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                // Contact/Social Links
                VStack(spacing: 12) {
                    LinkButton(icon: "envelope.fill", text: "Email", url: "mailto:sean@seanduran.com")
                    LinkButton(icon: "link", text: "Website", url: "https://seanduran.com")
                    LinkButton(icon: "person.crop.circle", text: "GitHub", url: "https://github.com/esotericsean")
                }
                .frame(width: UIScreen.main.bounds.width - 40)  // Constrain width
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .padding(.bottom, 90)
    }
    
    private var safeAreaInsets: EdgeInsets {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else { return EdgeInsets() }
        
        let insets = window.safeAreaInsets
        return EdgeInsets(
            top: insets.top,
            leading: insets.left,
            bottom: insets.bottom,
            trailing: insets.right
        )
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
        .frame(width: UIScreen.main.bounds.width - 80)  // Further constrain button width
    }
}
