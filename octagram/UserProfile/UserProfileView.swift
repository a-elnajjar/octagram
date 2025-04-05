//
//  UserProfileView.swift
//  octagram
//
//  Created by Abdalla Elnajjar on 2025-04-05.
//

import SwiftUI

struct UserProfileView: View {
    let username: String
    @StateObject private var userProfileVM = UserProfileViewModel()

    var body: some View {
        VStack {
            if userProfileVM.isLoading {
                ProgressView("Loading profile...")
            } else if let user = userProfileVM.user {
                // url Image for avatarURL
                AsyncImage(url: URL(string: user.avatarURL)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                // name or login
                Text(user.name ?? user.login)
                    .font(.title)
                // user bio
                Text(user.bio ?? "")
                    .font(.caption)
                    .multilineTextAlignment(.center)

                HStack(spacing: 8) {
                    // followers
                    NavigationLink(destination: EmptyView()) {
                        Text("\(user.followers) followers")
                            .foregroundColor(.blue)
                    }

                    Text("•")
                        .foregroundColor(.gray)

                    // following
                    NavigationLink(destination: EmptyView()) {
                        Text("\(user.following) following")
                            .foregroundColor(.blue)
                    }
                }

            } else if let error = userProfileVM.errorMessage {
                Text(error).foregroundColor(.red)
            }
            Spacer()
        }
        .padding()
        .navigationTitle(username)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await userProfileVM.fetchUserProfile(username)
        }
    }
}

#Preview {
    UserProfileView(username: "a-elnajjar")
}
