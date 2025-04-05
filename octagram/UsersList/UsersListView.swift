//
//  UsersListView.swift
//  octagram
//
//  Created by Abdalla Elnajjar on 2025-04-05.
//

import SwiftUI

struct UsersListView: View {
    // MARK: - variables

    @State private var selectedTab = "Following"
    var tabs = ["Following", "Followers"]
    @StateObject private var usersListVM = UsersListViewModel()
    let username: String

    // MARK: - body

    var body: some View {
        VStack {
            // pikker ui
            Picker("Select ", selection: $selectedTab) {
                ForEach(tabs, id: \.self) {
                    Text($0)
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
                            NavigationLink(destination: UserProfileView(username: user.login)) {
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
            let type: UserListingType = (selectedTab == "Followers") ? .followers : .following
            await usersListVM.fetchUsers(username: username, typeOflesting: type)
        }
    }
}

#Preview {
    UsersListView(username: "a-elnajjar")
}
