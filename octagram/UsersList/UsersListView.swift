//
//  UsersListView.swift
//  octagram
//
//  Created by Abdalla Elnajjar on 2025-04-05.
//

import SwiftUI

struct UsersListView: View {
    // MARK: - variables

    @State private var selectedTab: UserListingType
    @StateObject private var usersListVM: UsersListViewModel
    private let apiClient: APIService
    let username: String

    init(username: String, initialTab: UserListingType = .following, apiClient: APIService) {
        self.username = username
        self.apiClient = apiClient
        _selectedTab = State(initialValue: initialTab)
        _usersListVM = StateObject(wrappedValue: UsersListViewModel(apiClient: apiClient))
    }

    // MARK: - body

    var body: some View {
        VStack {
            // pikker ui
            Picker("Select ", selection: $selectedTab) {
                ForEach(UserListingType.allCases) {
                    Text($0.title)
                        .tag($0)
                }
            }
            .pickerStyle(.segmented)

            // User list
            if usersListVM.isLoading {
                ProgressView("Loading...")

            } else if let error = usersListVM.errorMessage {
                Text(error)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(usersListVM.users) { user in
                            NavigationLink(destination: UserProfileView(username: user.login, apiClient: apiClient)) {
                                HStack {
                                    if let avatarURL = user.avatarURL, let url = URL(string: avatarURL) {
                                        AsyncImage(url: url) { image in
                                            image.resizable()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                    }

                                    Text(user.login)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .background(Color(.systemBackground))
                            }
                            .overlay(
                                Divider()
                                    .padding(.leading, 100),
                                alignment: .bottom
                            )
                        }
                    }
                }
            }
        }
        .navigationTitle(username)
        .navigationBarTitleDisplayMode(.inline)
        .task(id: selectedTab) {
            await usersListVM.fetchUsers(username: username, type: selectedTab)
        }
    }
}

#Preview {
    UsersListView(username: "a-elnajjar", apiClient: APIClient.previewClient())
}
