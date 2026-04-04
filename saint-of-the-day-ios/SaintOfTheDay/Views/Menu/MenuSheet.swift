import SwiftUI

struct MenuSheet: View {
    let saint: Saint?
    @AppStorage("appColorScheme") private var storedScheme: String = "system"
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    Text("Sacred Resources")
                        .font(.saintHeading)
                        .foregroundStyle(Color.inkBrown)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 28)
                        .padding(.bottom, 16)

                    GoldDivider()

                    // Content rows
                    VStack(spacing: 0) {
                        NavigationLink {
                            DailyPrayerView()
                        } label: {
                            MenuRow(
                                icon: "book.closed.fill",
                                label: "Daily Prayer",
                                color: Color.frescoRed
                            )
                        }
                        .buttonStyle(.plain)

                        GoldDivider().padding(.leading, 64)

                        NavigationLink {
                            DailyReadingsView()
                        } label: {
                            MenuRow(
                                icon: "text.book.closed",
                                label: "Mass Readings",
                                color: Color.ancientGold
                            )
                        }
                        .buttonStyle(.plain)

                        GoldDivider().padding(.leading, 64)

                        NavigationLink {
                            LiturgicalCalendarView()
                        } label: {
                            MenuRow(
                                icon: "calendar.badge.clock",
                                label: "Liturgical Calendar",
                                color: Color.inkBrown
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    GoldDivider()

                    // Share row
                    if let saint {
                        ShareLink(item: shareText(for: saint)) {
                            MenuRow(
                                icon: "square.and.arrow.up",
                                label: "Share Today's Saint",
                                color: Color.inkBrown,
                                showChevron: false
                            )
                        }
                        .buttonStyle(.plain)

                        GoldDivider()
                    }

                    // Appearance row
                    AppearanceRow(storedScheme: $storedScheme)

                    GoldDivider()

                    Spacer(minLength: 40)
                }
            }
            .background(Color.parchment.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(Color.inkBrown.opacity(0.4))
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Color.parchment)
    }

    private func shareText(for saint: Saint) -> String {
        var text = "Saint of the Day: \(saint.canonicalName)\n"
        text += "Feast Day: \(saint.feastDay)\n"
        if let period = saint.timePeriod { text += "\(period)\n" }
        text += "\n\(saint.shortBio)"
        return text
    }
}

// MARK: - Supporting Views

private struct MenuRow: View {
    let icon: String
    let label: String
    let color: Color
    var showChevron: Bool = true

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(0.12))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(color)
            }

            Text(label)
                .font(.saintBody)
                .foregroundStyle(Color.inkBrown)

            Spacer()

            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.inkBrown.opacity(0.3))
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
    }
}

private struct AppearanceRow: View {
    @Binding var storedScheme: String

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.inkBrown.opacity(0.12))
                    .frame(width: 40, height: 40)
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.inkBrown)
            }

            Text("Appearance")
                .font(.saintBody)
                .foregroundStyle(Color.inkBrown)

            Spacer()

            Picker("Appearance", selection: $storedScheme) {
                Text("Light").tag("light")
                Text("System").tag("system")
                Text("Dark").tag("dark")
            }
            .pickerStyle(.segmented)
            .frame(width: 160)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
    }
}

private struct GoldDivider: View {
    var body: some View {
        Divider()
            .overlay(Color.ancientGold.opacity(0.25))
    }
}
