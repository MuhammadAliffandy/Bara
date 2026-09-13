import SwiftUI
import SwiftData

struct RecapLogView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \WorkSession.createdAt, order: .reverse) private var sessions: [WorkSession]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                if sessions.isEmpty {
                    VStack(spacing: AppSpacing.medium) {
                        Image(systemName: "tray")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        AppText(
                            text: "No recap history yet.",
                            textColor: .gray,
                            fontStyle: .appHeadline
                        )
                    }
                } else {
                    List {
                        ForEach(sessions) { session in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    AppText(
                                        text: session.status.capitalized,
                                        textColor: session.status == "commit" ? .primaryColorPurple : .textColorPrimaryOrange,
                                        fontStyle: .appHeadline
                                    )
                                    AppText(
                                        text: formatDate(session.createdAt),
                                        textColor: .gray,
                                        fontStyle: .appCaption
                                    )
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 4) {
                                    AppText(
                                        text: "\(Int(session.timerDuration / 60)) Min",
                                        textColor: .black,
                                        fontStyle: .appTitle
                                    )
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Recap History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Close")
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryColorPurple)
                    }
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    RecapLogView()
}
