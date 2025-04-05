//
//  SearchView.swift
//  octagram
//
//  Created by Abdalla Elnajjar on 2025-04-05.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var searchVM = SearchViewModel()
    @State private var showingError = false

    var body: some View {
        NavigationStack {
            ScrollView {
                // I use LazyVStack to render Item when need it
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(searchVM.results) { user in
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
                                } else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.gray)
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
                                .padding(.leading, 6),
                            alignment: .bottom
                        )
                    }
                }
            }
            .navigationTitle("Search GitHub Profiles")
            .searchable(text: $searchVM.query, prompt: "Search for GitHub Profile")
            .onChange(of: searchVM.query) {
                searchVM.searchUsers()
            }
            .overlay {
                if searchVM.isLoading {
                    ProgressView("Searching...")
                } else if !searchVM.isLoading && !searchVM.query.isEmpty && searchVM.results.isEmpty {
                    Text("No results found")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            // show UIAlert when we have error
            .alert("Error", isPresented: .constant(searchVM.errorMessage != nil), presenting: searchVM.errorMessage) { _ in
                Button("OK", role: .cancel) {
                    searchVM.errorMessage = nil
                }
            } message: { error in
                Text(error)
            }
        }
    }
}

#Preview {
    SearchView()
}
