//
//  OctagramApp.swift
//  octagram
//
//  Created by Abdalla Elnajjar on 2025-04-05.
//

import SwiftUI

@main
struct OctagramApp: App {
    private let apiClient = APIClient.makeDefault()

    var body: some Scene {
        WindowGroup {
            ContentView(apiClient: apiClient)
        }
    }
}
