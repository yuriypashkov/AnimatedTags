//
//  TagsViewModel.swift
//  AnimatedTags
//
//  Created by Yuriy Pashkov on 17.05.2024.
//

import Foundation


class TagsViewModel: ObservableObject {
    @Published var tags: [String] = ["macOS", "Windows", "Linux", "iOS", "Android", "iPadOS", "visionOS", "watchOS", "tvOS", "Swift", "SwiftUI", "UIKit", "Kotlin", "Java", "JavaScript", "C", "C#", "C++"]
    
    @Published var selectedTags: [String] = []
    
    func filterSelectedTags() -> [String] {
        tags.filter { !selectedTags.contains($0) }
    }
    
    func removeTag(_ tag: String) {
        selectedTags.removeAll { $0 == tag }
    }
}
