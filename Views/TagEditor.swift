import SwiftUI

struct TagEditor: View {
    @Binding var tags: Set<String>
    @State private var newTag = ""
    @StateObject private var tagManager = TagManager()
    
    init(tags: Binding<Set<String>>) {
        self._tags = tags
        self._tagManager = StateObject(wrappedValue: TagManager(initialTags: tags.wrappedValue))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                TextField("Add tag", text: $newTag)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        addTag()
                    }
                    .onChange(of: newTag) { newValue in
                        if newValue.contains(",") {
                            let parts = newValue.split(separator: ",")
                            for part in parts {
                                addTagString(String(part))
                            }
                            newTag = ""
                        }
                    }
                
                Button(action: addTag) {
                    Image(systemName: "plus.circle.fill")
                }
                .disabled(newTag.isEmpty)
            }
            
            if !tagManager.tags.isEmpty {
                FlowLayout(spacing: 8) {
                    ForEach(Array(tagManager.tags).sorted(), id: \.self) { tag in
                        TagView(tag: tag) {
                            tagManager.removeTag(tag)
                            tags = tagManager.tags
                        }
                    }
                }
            }
        }
    }
    
    private func addTag() {
        let trimmed = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            tagManager.addTag(trimmed)
            tags = tagManager.tags
            newTag = ""
        }
    }
    
    private func addTagString(_ input: String) {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            tagManager.addTag(trimmed)
            tags = tagManager.tags
        }
    }
}

struct TagView: View {
    let tag: String
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(tag)
                .lineLimit(1)
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.blue.opacity(0.2))
        .cornerRadius(8)
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat
    
    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var height: CGFloat = 0
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if x + size.width > width {
                // Move to next row
                y += rowHeight + spacing
                x = 0
                rowHeight = size.height
            } else {
                // Stay on same row
                rowHeight = max(rowHeight, size.height)
            }
            
            x += size.width + spacing
            height = max(height, y + rowHeight)
        }
        
        return CGSize(width: width, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0
        let width = bounds.width
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if x + size.width > width + bounds.minX {
                // Move to next row
                y += rowHeight + spacing
                x = bounds.minX
                rowHeight = size.height
            } else {
                // Stay on same row
                rowHeight = max(rowHeight, size.height)
            }
            
            subview.place(
                at: CGPoint(x: x, y: y),
                proposal: ProposedViewSize(size)
            )
            
            x += size.width + spacing
        }
    }
}

class TagManager: ObservableObject {
    @Published var tags: Set<String>
    
    init(initialTags: Set<String> = []) {
        self.tags = initialTags
    }
    
    func addTag(_ tag: String) {
        tags.insert(tag)
    }
    
    func removeTag(_ tag: String) {
        tags.remove(tag)
    }
} 
