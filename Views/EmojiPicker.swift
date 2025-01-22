import SwiftUI

struct EmojiPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedEmoji: String
    @State private var searchText = ""
    
    // Categories of emojis
    let categories = [
        "Frequently Used": ["📍", "⭐️", "🏠", "🏢", "🎯", "📌", "🎪", "🏛"],
        "Places": ["🏠", "🏢", "🏫", "🏥", "🏪", "🏭", "⛪️", "🏛", "🏗", "🏘", "🏚", "🏨", "🏦", "🏬", "🏯", "🏰", "💒", "🗼", "🗽"],
        "Nature": ["🌲", "🌳", "🌴", "🌵", "🌷", "🌸", "🌹", "🌺", "🌻", "🌼", "🍀", "🌿", "☘️", "🍂", "🍁", "🌾"],
        "Food": ["🍕", "🍔", "🍟", "🌭", "🍿", "🧂", "🥨", "🥪", "🌮", "🌯", "🥙", "🧆", "🥚", "🍳", "🥘", "🍲", "🥣"],
        "Activities": ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉", "🥏", "🎱", "🪀", "🏓", "🏸", "🏒", "🏑", "🥍"],
        "Travel": ["✈️", "🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🛵", "🏍"],
        "Symbols": ["❤️", "💙", "💚", "💛", "💜", "🖤", "🤍", "🤎", "💔", "❣️", "💕", "💞", "💓", "💗", "💖", "💘"]
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    TextField("Search Emoji", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    ForEach(Array(categories.keys).sorted(), id: \.self) { category in
                        VStack(alignment: .leading) {
                            Text(category)
                                .font(.headline)
                                .padding(.horizontal)
                            
                            let emojis = categories[category] ?? []
                            let filteredEmojis = emojis.filter { searchText.isEmpty || $0.contains(searchText) }
                            
                            if !filteredEmojis.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(filteredEmojis, id: \.self) { emoji in
                                            Button {
                                                selectedEmoji = emoji
                                                dismiss()
                                            } label: {
                                                Text(emoji)
                                                    .font(.system(size: 40))
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    
                    if !searchText.isEmpty {
                        VStack {
                            Text("Type any emoji in the search field!")
                                .foregroundColor(.secondary)
                            
                            if searchText.containsOnlyEmoji {
                                Button {
                                    selectedEmoji = searchText
                                    dismiss()
                                } label: {
                                    Text("Use '\(searchText)'")
                                        .foregroundColor(.blue)
                                        .padding()
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Select Emoji")
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
    }
}

extension String {
    var containsOnlyEmoji: Bool {
        !isEmpty && !contains { !$0.isEmoji }
    }
}

extension Character {
    var isEmoji: Bool {
        guard let scalar = unicodeScalars.first else { return false }
        return scalar.properties.isEmoji && (scalar.value > 0x238C || scalar.value < 0x1F3FB)
    }
}
