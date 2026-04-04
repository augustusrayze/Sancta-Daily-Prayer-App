import SwiftUI

struct TodayView: View {
    @State private var viewModel = TodayViewModel()
    @State private var showDetail = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.parchment.ignoresSafeArea()

                if viewModel.isLoading {
                    LoadingView()
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error) {
                        Task { await viewModel.refresh() }
                    }
                } else if let saint = viewModel.saint {
                    ScrollView {
                        VStack(spacing: 16) {
                            SaintHeroCard(saint: saint)
                                .frame(height: UIScreen.main.bounds.height * 0.45)
                                .padding(.horizontal, 16)

                            QuickBioSnippet(saint: saint)
                                .padding(.horizontal, 16)

                            Button {
                                showDetail = true
                            } label: {
                                HStack {
                                    Text("Read Full Story")
                                        .font(.saintBody)
                                    Image(systemName: "arrow.right")
                                }
                                .foregroundStyle(Color.parchment)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.ancientGold)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 24)
                        }
                        .padding(.top, 8)
                    }
                    .refreshable {
                        await viewModel.refresh()
                    }
                    .navigationDestination(isPresented: $showDetail) {
                        SaintDetailView(saint: saint)
                    }
                }
            }
            .navigationTitle("Saint of the Day")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.parchment, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .task {
            await viewModel.loadIfNeeded()
        }
        .onAppear {
            NotificationService.shared.clearBadge()
        }
    }
}
