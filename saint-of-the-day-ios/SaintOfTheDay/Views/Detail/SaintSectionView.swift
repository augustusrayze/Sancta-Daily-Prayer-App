import SwiftUI

struct SaintSectionView: View {
    let section: SaintSection

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon(for: section.kind))
                    .foregroundStyle(Color.ancientGold)
                    .frame(width: 20)
                Text(section.heading)
                    .font(.saintHeading)
                    .foregroundStyle(Color.inkBrown)
            }

            GoldDivider()

            Text(section.body)
                .font(.saintBody)
                .foregroundStyle(Color.inkBrown)
                .lineSpacing(5)
        }
        .padding(16)
        .cardStyle()
    }

    private func icon(for kind: SectionKind) -> String {
        switch kind {
        case .biography:    return "person.fill"
        case .miracles:     return "sparkles"
        case .writings:     return "book.fill"
        case .patronages:   return "shield.fill"
        case .canonization: return "crown.fill"
        case .other:        return "info.circle"
        }
    }
}
