//
//  ContentView.swift
//  octagram
//
//  Created by Abdalla Elnajjar on 2025-04-05.
//

import SwiftUI

struct ContentView: View {
    private let apiClient: APIService

    init(apiClient: APIService) {
        self.apiClient = apiClient
    }

    var body: some View {
        SearchView(apiClient: apiClient)
    }
}

#Preview {
    ContentView(apiClient: APIClient.previewClient())
}
