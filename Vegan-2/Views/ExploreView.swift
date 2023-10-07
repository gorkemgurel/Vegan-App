//
//  ExploreView.swift
//  Vegan-2
//
//  Created by Gorkem Gurel on 30.07.2023.
//

import Foundation
import SwiftUI

struct ExploreView: View {
    //@StateObject var recipeStore = RecipeStore.shared
    @StateObject var recipeViewModel = RecipeViewModel.shared
    @State var readyToNavigateToRecipe = false
    @State private var searchText = ""
    
        var body: some View {
            NavigationStack {
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(width: 0, height: 0)
                        TextField(" Search", text: $searchText)
                            .frame(height: 4)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 2) {
                            ForEach(recipeViewModel.recipes.indices, id: \.self) { index in
                                if let id = recipeViewModel.recipes[index].id {
                                    if let coverImage = recipeViewModel.uniqueRecipes[id]?.coverPhoto {
                                        NavigationLink(value: id) {
                                            Image(uiImage: coverImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
                                                .clipped()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }.navigationDestination(for: String.self) { value in
                    RecipeView(recipeID: value)
                }
            }
        }
}

struct Previews_ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
